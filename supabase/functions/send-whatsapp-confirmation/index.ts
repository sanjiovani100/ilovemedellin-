// I Love Medellin - WhatsApp Confirmation Function
// File: supabase/functions/send-whatsapp-confirmation/index.ts

import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const WATI_API_URL = 'https://live-server-113452.wati.io/api/v1'
const WATI_API_TOKEN = Deno.env.get('WATI_API_TOKEN')!

serve(async (req: Request) => {
  try {
    const { 
      payment_intent_id,
      booking_id,
      phone,
      amount,
      currency,
      description,
      message_type = 'booking_confirmation',
      language = 'es'
    } = await req.json()
    
    if (!phone) {
      return new Response(JSON.stringify({ error: 'Phone number is required' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' }
      })
    }

    const cleanPhone = phone.replace(/\+/g, '').replace(/\s/g, '')
    
    let message: string
    
    if (message_type === 'booking_confirmation') {
      message = generateBookingConfirmation(amount, currency, description, booking_id, language)
    } else {
      message = generatePaymentConfirmation(amount, currency, payment_intent_id, language)
    }

    // Send WhatsApp message
    const result = await sendWhatsAppMessage(cleanPhone, message)

    return new Response(JSON.stringify({
      success: result.success,
      message_id: result.messageId,
      phone: cleanPhone
    }), {
      headers: { 'Content-Type': 'application/json' }
    })

  } catch (error) {
    console.error('WhatsApp confirmation error:', error)
    return new Response(JSON.stringify({ 
      error: 'Failed to send WhatsApp message' 
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' }
    })
  }
})

function generateBookingConfirmation(amount: number, currency: string, description: string, bookingId: string, language: string): string {
  const formattedAmount = formatCurrency(amount || 0, currency || 'COP')
  
  if (language === 'en') {
    return `Hi! 🎉

Your booking is confirmed:
📍 ${description || 'Medellín Experience'}
💰 Total: ${formattedAmount}
📱 Booking ID: ${bookingId}

Any questions? Just reply to this message!

*I Love Medellín* 💚`
  }
  
  return `¡Hola! 🎉

Tu reserva ha sido confirmada:
📍 ${description || 'Experiencia en Medellín'}
💰 Total: ${formattedAmount}
📱 Código: ${bookingId}

¿Tienes alguna pregunta? ¡Responde a este mensaje!

*I Love Medellín* 💚`
}

function generatePaymentConfirmation(amount: number, currency: string, paymentId: string, language: string): string {
  const formattedAmount = formatCurrency(amount || 0, currency || 'COP')
  
  if (language === 'en') {
    return `Payment confirmed! 💚

Amount: ${formattedAmount}
ID: ${paymentId}

Thank you for choosing I Love Medellín! 🇨🇴`
  }
  
  return `¡Pago confirmado! 💚

Monto: ${formattedAmount}
ID: ${paymentId}

¡Gracias por elegir I Love Medellín! 🇨🇴`
}

async function sendWhatsAppMessage(phone: string, message: string) {
  try {
    const response = await fetch(`${WATI_API_URL}/sendSessionMessage`, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${WATI_API_TOKEN}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        phoneNumber: phone,
        message: message
      })
    })

    const result = await response.json()
    return {
      success: response.ok,
      messageId: result.messageId,
      response: result
    }

  } catch (error) {
    return {
      success: false,
      error: error.message
    }
  }
}

function formatCurrency(amount: number, currency: string): string {
  return new Intl.NumberFormat('es-CO', {
    style: 'currency',
    currency: currency.toUpperCase(),
    minimumFractionDigits: 0
  }).format(amount)
}
