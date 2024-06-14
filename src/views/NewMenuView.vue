<script setup lang="ts">
</script>

<template>
  <main class="new-menu">
    <button @click="$router.push({name: 'food'})">
      FOOD
    </button>
    <button @click="$router.push({name: 'water'})">
      WATER
    </button>
    <button @click="$router.push({name: 'weight'})">
      WEIGHT
    </button>
  </main>
</template>

<style scoped lang="scss">
@import '@/styles/variables.scss';

main {
  padding: 0 16px;
  padding-top: calc(60px + var(--safe-area-inset-top));
  padding-bottom: calc(48px + var(--safe-area-inset-bottom) + 60px);
  height: 100%;
  overflow-y: auto;
}

button {
  margin: 12px 0;
}
</style>