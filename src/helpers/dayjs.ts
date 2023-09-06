import dayjs from 'dayjs';
import utc from 'dayjs/plugin/utc';

dayjs.extend(utc);

export function formatTimeToHHMM(dateString: string): string {
  return dayjs.utc(dateString).local().format('HH:mm');
}