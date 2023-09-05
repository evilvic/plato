<template>
  <nav class="navigation">
    <p>Nuevo</p>
  </nav>

</template>

<style scoped lang="scss">
@import '@/styles/variables.scss';

.navigation {
  width: 100%;
  height: 75px;
  background-color: $bg-39;
  position: fixed;
  bottom: 0;
  & p {
    color: #999999;
  }
}
</style>