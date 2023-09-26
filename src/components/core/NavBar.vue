<template>
  <nav class="navbar">
    
  </nav>
</template>

<style scoped lang="scss">
@import '@/styles/variables.scss';

.navbar {
  width: 100%;
  height: calc(60px + var(--safe-area-inset-top));
  background: rgba(41, 41, 41, 0.75);
  backdrop-filter: blur(10px);
  position: fixed;
  top: 0;
  display: flex;
  gap: 2px;
  padding: 2px;
  z-index: 1000;
}

</style>