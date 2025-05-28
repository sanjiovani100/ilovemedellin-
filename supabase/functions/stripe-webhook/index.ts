// I Love Medellin - Stripe Webhook Handler
// File: supabase/functions/stripe-webhook/index.ts

import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import Stripe from 'https://esm.sh/stripe@12.18.0'

const stripe = new Stripe(Deno.env.get('STRIPE_SECRET_KEY') || '', {
  apiVersion: '2023-10-16',
})

const supabaseUrl = Deno.env.get('SUPABASE_URL')!
const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
const supabase = createClient(supabaseUrl, supabaseServiceKey)

serve(async (req: Request) => {
  try {
    const signature = req.headers.get('stripe-signature')
    if (!signature) {
      return new Response('No signature', { status: 400 })
    }

    const body = await req.text()
    
    // Verify webhook signature
    const event = stripe.webhooks.constructEvent(
      body,
      signature,
      Deno.env.get('STRIPE_WEBHOOK_SECRET')!
    )

    console.log(`Processing webhook: ${event.type}`)

    // Process the event based on type
    switch (event.type) {
      case 'payment_intent.succeeded':
        await handlePaymentSucceeded(event.data.object as Stripe.PaymentIntent)
        break
      
      case 'payment_intent.payment_failed':
        await handlePaymentFailed(event.data.object as Stripe.PaymentIntent)
        break
      
      default:
        console.log(`Unhandled event type: ${event.type}`)
    }

    return new Response('Webhook processed successfully', { status: 200 })

  } catch (error) {
    console.error('Webhook processing error:', error)
    return new Response('Webhook error', { status: 400 })
  }
})

async function handlePaymentSucceeded(paymentIntent: Stripe.PaymentIntent) {
  console.log(`Processing payment succeeded: ${paymentIntent.id}`)
  
  // Update booking status if exists
  const bookingId = paymentIntent.metadata.booking_id
  if (bookingId) {
    await supabase
      .from('bookings')
      .update({
        payment_status: 'paid',
        status: 'confirmed'
      })
      .eq('id', bookingId)

    // Trigger WhatsApp confirmation
    await triggerWhatsAppConfirmation(paymentIntent)
  }
}

async function handlePaymentFailed(paymentIntent: Stripe.PaymentIntent) {
  const bookingId = paymentIntent.metadata.booking_id
  if (bookingId) {
    await supabase
      .from('bookings')
      .update({
        payment_status: 'failed',
        status: 'cancelled'
      })
      .eq('id', bookingId)
  }
}

async function triggerWhatsAppConfirmation(paymentIntent: Stripe.PaymentIntent) {
  const phone = paymentIntent.metadata.whatsapp_phone
  if (phone) {
    await supabase.functions.invoke('send-whatsapp-confirmation', {
      body: {
        payment_intent_id: paymentIntent.id,
        phone: phone,
        amount: paymentIntent.amount / 100,
        currency: paymentIntent.currency,
        booking_id: paymentIntent.metadata.booking_id
      }
    })
  }
}
