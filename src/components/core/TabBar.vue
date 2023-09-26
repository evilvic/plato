<template>
  <nav class="navigation">
    <button 
      class="navigation__el"
      :class="{'navigation__el--active': $route.name === 'diary'}"
      @click="$router.push({name: 'diary'})"
    >
      <div class="navigation__icon"/>
      <span class="navigation__topic">Diario</span>
    </button>
    <button class="navigation__el">
      <div class="navigation__icon" />
      <span class="navigation__topic">-</span>
    </button>
    <button 
      class="navigation__el"
      :class="{'navigation__el--active': $route.name === 'new'}"
      @click="$router.push({name: 'new'})"
    >
      <div class="navigation__icon" />
      <span class="navigation__topic">Nuevo</span>
    </button>
    <button class="navigation__el">
      <div class="navigation__icon" />
      <span class="navigation__topic">-</span>
    </button>
    <button class="navigation__el">
      <div class="navigation__icon" />
      <span class="navigation__topic">-</span>
    </button>
  </nav>
</template>

<style scoped lang="scss">
@import '@/styles/variables.scss';

.navigation {
  width: 100%;
  height: calc(48px + var(--safe-area-inset-bottom));
  background: rgba(41, 41, 41, 0.75);
  backdrop-filter: blur(20px);
  position: fixed;
  bottom: 0;
  display: flex;
  gap: 2px;
  padding: 2px;
  &__el {
    width: 44px;
    height: 44px;
    background: transparent;
    border: none;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    align-items: center;
    flex: 1;
    padding: 4px 0 2px;
  }
  &__icon {
    width: 24px;
    height: 24px;
    background: $bg-99;
  }
  &__topic {
    font-size: 10px;
    line-height: 10px;
    color: $bg-99;
  }
}
.navigation__el--active {
  background: $bg-39;
  border-radius: 4px;
  & .navigation__icon {
    background: $white-fd;
  }
  & .navigation__topic {
    color: $white-fd;
  }
}
</style>