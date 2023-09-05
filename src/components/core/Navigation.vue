<template>
  <nav class="navigation">
    <button class="navigation__el">
      <div class="navigation__icon" />
      <span class="navigation__topic">Item</span>
    </button>
    <button class="navigation__el">
      <div class="navigation__icon" />
      <span class="navigation__topic">Item</span>
    </button>
    <button class="navigation__el">
      <div class="navigation__icon" />
      <span class="navigation__topic">Item</span>
    </button>
    <button class="navigation__el">
      <div class="navigation__icon" />
      <span class="navigation__topic">Item</span>
    </button>
    <button class="navigation__el">
      <div class="navigation__icon" />
      <span class="navigation__topic">Item</span>
    </button>
  </nav>

</template>

<style scoped lang="scss">
@import '@/styles/variables.scss';

.navigation {
  width: 100%;
  height: calc(48px + var(--safe-area-inset-bottom));
  background: $bg-29;
  position: fixed;
  bottom: 0;
  display: flex;
  gap: 2px;
  padding: 2px;
  &__el {
    width: 40px;
    height: 44px;
    background: transparent;
    border: none;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    align-items: center;
    flex: 1;
    padding-top: 4px;
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
</style>