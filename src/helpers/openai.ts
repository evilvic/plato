import OpenAI from "openai";

const apiKey = import.meta.env.VITE_OPENAI_KEY

const openai = new OpenAI({
  apiKey,
  dangerouslyAllowBrowser: true,
});

export async function analyzeFoodEntry(description: string) {
  const response = await openai.chat.completions.create({
    model: "gpt-3.5-turbo",
    messages: [
      {
        role: "system",
        content: `
          You are a nutrition analysis assistant. Your task is to parse the user's 
          input of food descriptions, break them down into individual items, classify 
          each in terms of type and quantity, provide nutritional information 
          (calories, fats, proteins, sugars) for each, and calculate the total 
          nutritional value. Always respond in JSON format following the given structure:

          Input: "una manzana, dos huevos revueltos con jamón, un vaso de leche"

          Expected Output Format:
          {
            "items": [
              {
                "alimento": "[nombre]",
                "cantidad": "[cantidad]",
                "calorias": "[valor]",
                "grasas": "[valor]",
                "proteinas": "[valor]",
                "azucares": "[valor]"
              },
              ...
            ],
            "total": {
              "calorias": "[valor]",
              "grasas": "[valor]",
              "proteinas": "[valor]",
              "azucares": "[valor]"
            }
          }
        `,
    },
    {
      role: "user",
      content: `
      A partir de la siguiente descripción de alimentos, desglosa los elementos 
      individuales, clasifica cada uno en términos de tipo y cantidad, proporciona 
      la información nutricional (calorías, grasas, proteínas, azúcares) para cada 
      uno y calcula el valor nutricional total. Proporciona el resultado en formato JSON:

      Descripción: "${description}"`,
    },],
  });

  console.log(response.choices[0].message.content);
  return response.choices[0].message.content;
}
