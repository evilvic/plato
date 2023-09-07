import dayjs from 'dayjs';
import localeData from 'dayjs/plugin/localeData'
import utc from 'dayjs/plugin/utc';
import 'dayjs/locale/es';

dayjs.extend(utc);
dayjs.extend(localeData)
dayjs.locale('es');

export function formatTimeToHHMM(dateString: string): string {
  return dayjs.utc(dateString).local().format('HH:mm');
}

export function formatDateToYYYYMMDD(dateString: string): string {
  return dayjs.utc(dateString).local().format('YYYY-MM-DD');
}

export const formatDateWithTodayAndYesterday = (date: string) => {
  const today = dayjs();
  const inputDate = dayjs(date);
  
  if (inputDate.isSame(today, 'day')) {
      return `HOY | ${inputDate.format('D [de] MMMM')}`;
  } else if (inputDate.isSame(dayjs(today).subtract(1, 'day'), 'day')) {
      return `AYER | ${inputDate.format('D [de] MMMM')}`;
  } else {
      return `${inputDate.format('dddd | D [de] MMMM')}`;
  }
}
