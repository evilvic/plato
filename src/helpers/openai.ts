import OpenAI from "openai";

const apiKey = import.meta.env.VITE_OPENAI_KEY

const openai = new OpenAI({
  apiKey,
  dangerouslyAllowBrowser: true,
});

export async function analyzeFoodEntry() {
  const response = await openai.chat.completions.create({
    model: "gpt-3.5-turbo",
    messages: [{ role: "system", content: "You are a helpful assistant." }],
  });

  console.log(response.choices[0]);
}
