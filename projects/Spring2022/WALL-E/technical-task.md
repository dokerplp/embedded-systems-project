# Техническое задание по проекту "Дистанционное управление колёсным роботом"
# Кодовое имя: "WALL-E"


## Общие сведения

1. **Цель проекта:**  
    Восстановление и доработка колёсного робота. Разработка и(или) доработка системы дистанционного управления роботом, включающей в себе ПО для робота и мобильное(-ые) приложение(-я) для управления.  

2. **Команда исполнителей**:  
    * Пименов Данила P3230 - Team leader, Back-end разработчик  
    * Абузов Ярослав P3230 - Инженер-механик, Back-end разработчик  
    * Буторин Валерий P3231 - Мобильный-разработчик, Back-end разработчик

## Технические требования

<ol type="1">
    <li><b>Требования к функциональным характеристикам.</b></li>
    <ol type="1">
        <li>Техническая возможность раздельного управления каждым двигателем.</li>
        <li>Плавная регулировка скорости движения.</li>
        <li>Питание робот получает от аккумуляторных батарей.</li>
        <li>Контроль заряда батарей.</li>
        <li>Робот должен перемещаться в любом направлении в горизонтальной плоскости.</li>
        <li>Наличие камеры наблюдения на роботе для оператора.</li>
        <li>Изображение с камеры должно передаваться на устройство управления.</li>
        <li>Основной способ управления - мобильное приложение.</li>
        <li>Мобильное приложение автоматически подключается к роботу.</li>
        <li>При обрыве связи робот должен остановиться, а приложения должно пытаться переподключиться.</li>
        <li>Экспериментальный способ управления - автономное упправление на основе компьютерного зрения.</li>
        <li>Автономное управление обеспечивает перемещение из точки А в точку Б по специальным маркерам, стрелкам или линии.</li>
    </ol>
    <li><b>Требования к надежности.</b></li>
    <ol>
        <li>Будут определены после получения документации на робота в текущем его состоянии. </li>
    </ol>    
    <li><b>Условия эксплуатации.</b></li>
    <ol>
        <li>Будут определены после получения документации на робота в текущем его состоянии. </li>
    </ol> 
    <li><b>Требования к составу и параметрам технических средств.</b></li>
    <ol>
        <li>Будут определены после получения документации на робота в текущем его состоянии. </li>
    </ol> 
    <li><b>Требования к информационной и программной совместимости.</b></li>
    В рамках проекта должна быть разработана программная система, обеспечивающая дистанционное управление роботом.</br></br>  
    <b>Система должна в себя включать следующие модули:</b>
    <ol type="1">
        <li>Клиентское ПО (мобильное приложение)</li>
        <li>Сервер промежуточной обработки данных, соединяющий клиентское приложение с роботом (может находится на самом роботе)</li>
        <li>ПО для робота, обеспечивающее непосредственное управление.</li>
        </br>
        <b>Интерфейсы управления:</b>
        <ol type="1">
            <li>Bluetooth</li>
            <li>Wi-Fi</li>
            <li>GSM (возможно, много накладных расходов)</li>
        </ol>
    </ol>
    <li><b>Требования к транспортированию и хранению.</b></li>
    <ol type="1">
        <li>Хранить в защищённом от детей сухом месте.</li>
        <li>Не подвергать критическому давлению корпус и элементы передвижения.</li>
        <li>При длительном хранении - отключить аккумулоторы и переодичски их заряжать.</li>
        <li>Не допускать критического разряда аккумулторов.</li>
    </ol>
</ol>    


## Требования к документации

Должен быть указан состав программной документации и требования к ней.
  Перечень необходимой программной документации:

  1. Перечень всех API проекта
  2. Техническое задание на мобильное приложение
  3. Описание реализации мобильного приложения
  4. Техническое задание на сервер обработки данных
  5. Описание реализации сервера обработки данных
  6. Техническое задание на бортовое ПО робота
  7. Описание реализации бортового ПО

## Технико-экономические показатели

Техническая составляющая (цену на момент написания ТЗ указать не совсем возможно):

- 4x мощных двигателя (+ 4 колеса)
- HD камера (USB или специальная для PRi)
- 2x Raspberry Pi (не ниже 3 версии)
- Драйвер двигателя (количество зависит от характеристик самого драйвера)
- Преобразователи напряжения
- 2x аккумулятора
- Силовые провода
- Сигнальные провода
- Различная мелочёвка


## Cтадии и этапы разработки

В разделе устанавливают необходимые стадии разработки, этапы и содержание работ (перечень документов, которые должны быть разработаны, согласованы и утверждены), а также сроки разработки и распределение работ по исполнителям.
1. Получение исходных данных от предыдущих разработчиков проекта.
2. Согласование технического задания с куратором проекта.
3. Генерация технических заданий на ранее описанные модули проекта.
4. Согласование технических заданий и унификация API.
5. Разработка мобильного приложения. Ответственный: Буторин  
6. Разработка сервера обработки данных. Ответственный: Абузов  
7. Разработка бортового ПО. Ответственный: Пименов
9. Тестирование и отладка готовой программно-механической системы
10. Подготовка отчётной документации. Ответственный: Пименов

## Порядок контроля и приемки
В процессе приёмки работы должно быть проверено соответствие итогового продукта заявленным функциональным требованиям.  
Должны быть протестированы следующие функции:  
1. Работоспособность робота
2. Работоспособность управления с помощью мобильного приложения
3. Работоспособность трансляции изображения на устройство управления
4. Работоспособность автономного управления в экспериментальном режиме

## Ссылки на источники

1. ГОСТ 19.201-78 Техническое задание. Требования к содержанию и оформлению