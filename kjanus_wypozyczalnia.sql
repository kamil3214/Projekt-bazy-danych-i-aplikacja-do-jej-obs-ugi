-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Cze 10, 2023 at 01:48 AM
-- Wersja serwera: 10.4.28-MariaDB
-- Wersja PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `kjanus_wypozyczalnia`
--

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `dodatkowy_koszt`
--

CREATE TABLE `dodatkowy_koszt` (
  `Wypozyczenie_id` int(11) UNSIGNED NOT NULL,
  `Kwota` float DEFAULT NULL,
  `Komentarz` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `dodatkowy_koszt`
--

INSERT INTO `dodatkowy_koszt` (`Wypozyczenie_id`, `Kwota`, `Komentarz`) VALUES
(127, 1500, 'Urwane lusterko.'),
(130, 500, 'Zgubiony kluczyk.'),
(131, 800, 'Uszkodzona felga.'),
(136, 500, 'Porysowana karoseria.'),
(137, 300, 'Zgubiony kluczyk.');

--
-- Wyzwalacze `dodatkowy_koszt`
--
DELIMITER $$
CREATE TRIGGER `koszt_delete` AFTER DELETE ON `dodatkowy_koszt` FOR EACH ROW BEGIN
IF (old.Wypozyczenie_id IN (SELECT Wypozyczenie_id from rachunek)) THEN
UPDATE rachunek
SET rachunek.Naleznosc = (rachunek.Naleznosc - old.Kwota), rachunek.Dodatkowo = 0
WHERE rachunek.Wypozyczenie_id = old.Wypozyczenie_id;
END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `koszt_insert` AFTER INSERT ON `dodatkowy_koszt` FOR EACH ROW UPDATE rachunek
SET rachunek.Naleznosc = (rachunek.Naleznosc + new.Kwota), rachunek.Dodatkowo = 1
WHERE rachunek.Wypozyczenie_id = new.Wypozyczenie_id
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `koszt_update` AFTER UPDATE ON `dodatkowy_koszt` FOR EACH ROW UPDATE rachunek
SET rachunek.Naleznosc = (rachunek.Naleznosc + new.Kwota), rachunek.Dodatkowo = 1
WHERE rachunek.Wypozyczenie_id = new.Wypozyczenie_id
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `osoba`
--

CREATE TABLE `osoba` (
  `ID_pesel` bigint(15) UNSIGNED NOT NULL,
  `Imie` varchar(50) NOT NULL,
  `Nazwisko` varchar(50) NOT NULL,
  `Nr_telefonu` varchar(50) NOT NULL,
  `Adres` varchar(50) NOT NULL,
  `Historia_wyp_id` longtext DEFAULT NULL,
  `Aktywny` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `osoba`
--

INSERT INTO `osoba` (`ID_pesel`, `Imie`, `Nazwisko`, `Nr_telefonu`, `Adres`, `Historia_wyp_id`, `Aktywny`) VALUES
(31227922432, 'Zenona', 'Milewska', '259233789', 'Kielce 49-529 ul. Szkolna 17', '129, 133, 136, 139, 141', 1),
(34071496132, 'Maciej', 'Wojciechowski', '110868108', 'Konin 57-925 ul. Nowobielawska 4', '137, 138, 143', 1),
(52121460047, 'Hanna', 'Urbańska', '604517722', 'Tarnów 96-656 ul. Lipowa 12', '132', 0),
(52345225323, 'Jan', 'Nowak', '123456789', 'Wrocław 50-253 ul. Trzebnicka 103', '130, 135, 140, 142', 1),
(85051654552, 'Leszek', 'Błaszczyk', '235719932', 'Częstochowa 24-013 ul. Żytnia 91', '128, 131', 1),
(98011931871, 'Jan', 'Adamczyk', '123456789', 'Tychy 02-884 ul. Ogrodowa 23', '127, 134', 1);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `rachunek`
--

CREATE TABLE `rachunek` (
  `Wypozyczenie_id` int(11) UNSIGNED NOT NULL,
  `Osoba_id` bigint(15) UNSIGNED NOT NULL,
  `Rejestracja_id` varchar(50) NOT NULL,
  `Kilometry` int(11) DEFAULT NULL,
  `Ilosc_dni` int(11) DEFAULT NULL,
  `Naleznosc` float DEFAULT NULL,
  `Podliczono` tinyint(1) NOT NULL,
  `Oplacono` tinyint(1) NOT NULL DEFAULT 0,
  `Dodatkowo` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `rachunek`
--

INSERT INTO `rachunek` (`Wypozyczenie_id`, `Osoba_id`, `Rejestracja_id`, `Kilometry`, `Ilosc_dni`, `Naleznosc`, `Podliczono`, `Oplacono`, `Dodatkowo`) VALUES
(127, 98011931871, 'DSR4431', 800, 3, 2640, 1, 1, 1),
(128, 85051654552, 'KRA9116', 349, 3, 854.7, 1, 1, 0),
(129, 31227922432, 'PGS3832', 1257, 1, 627.1, 1, 1, 0),
(130, 52345225323, 'RJA5847', 1000, 2, 1200, 1, 1, 1),
(131, 85051654552, 'KRA9116', 500, 1, 1200, 1, 1, 1),
(132, 52121460047, 'RJA5847', 500, 1, 350, 1, 1, 0),
(136, 31227922432, 'WPI9539', 600, 1, 1300, 1, 1, 1),
(137, 34071496132, 'SB34864', 1000, 0, 700, 1, 1, 1),
(138, 34071496132, 'RJA5847', 500, 1, 350, 1, 0, 0),
(141, 31227922432, 'PGS3832', 500, 1, 400, 1, 1, 0),
(142, 52345225323, 'SB34864', 900, 2, 1220, 1, 0, 0),
(143, 34071496132, 'RJA5847', NULL, NULL, NULL, 0, 0, 0);

--
-- Wyzwalacze `rachunek`
--
DELIMITER $$
CREATE TRIGGER `dodatkowy_koszt_delete` BEFORE DELETE ON `rachunek` FOR EACH ROW DELETE from dodatkowy_koszt
WHERE old.Wypozyczenie_id = dodatkowy_koszt.Wypozyczenie_id
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `wylicz_insert` BEFORE INSERT ON `rachunek` FOR EACH ROW BEGIN
    IF (new.Wypozyczenie_id IN (Select Wypozyczenie_id from dodatkowy_koszt) ) THEN
SET new.Naleznosc = (new.Kilometry *( Select Cena_km FROM samochod WHERE samochod.ID_rejestracja = new.Rejestracja_id) + new.Ilosc_dni *( Select Cena_doba FROM samochod WHERE samochod.ID_rejestracja = new.Rejestracja_id)+ (Select Kwota FROM dodatkowy_koszt WHERE dodatkowy_koszt.Wypozyczenie_id = new.Wypozyczenie_id));
        ELSE
        SET new.Naleznosc = (new.Kilometry *( Select Cena_km FROM samochod WHERE samochod.ID_rejestracja = new.Rejestracja_id) + new.Ilosc_dni *( Select Cena_doba FROM samochod WHERE samochod.ID_rejestracja = new.Rejestracja_id));
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `wylicz_update` BEFORE UPDATE ON `rachunek` FOR EACH ROW BEGIN
    IF (new.Wypozyczenie_id IN (Select Wypozyczenie_id from dodatkowy_koszt) ) THEN
SET new.Naleznosc = (new.Kilometry *( Select Cena_km FROM samochod WHERE samochod.ID_rejestracja = new.Rejestracja_id) + new.Ilosc_dni *( Select Cena_doba FROM samochod WHERE samochod.ID_rejestracja = new.Rejestracja_id)+ (Select Kwota FROM dodatkowy_koszt WHERE dodatkowy_koszt.Wypozyczenie_id = new.Wypozyczenie_id));
        ELSE
        SET new.Naleznosc = (new.Kilometry *( Select Cena_km FROM samochod WHERE samochod.ID_rejestracja = new.Rejestracja_id) + new.Ilosc_dni *( Select Cena_doba FROM samochod WHERE samochod.ID_rejestracja = new.Rejestracja_id));
    END IF;
        IF (new.Kilometry IS NOT NULL and new.Ilosc_dni IS NOT NULL and new.Naleznosc IS NOT NULL and new.Kilometry >=0 and new.Ilosc_dni >=0 and new.Naleznosc >=0) THEN
    SET new.Podliczono = 1;
    ELSE
    SET new.Podliczono = 0, new.Oplacono = 0, new.Naleznosc = NULL;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `samochod`
--

CREATE TABLE `samochod` (
  `ID_rejestracja` varchar(50) NOT NULL,
  `Stan_licznika` bigint(15) NOT NULL,
  `Model` varchar(50) NOT NULL,
  `Sprawny` tinyint(1) NOT NULL DEFAULT 1,
  `W_garazu` tinyint(1) NOT NULL DEFAULT 1,
  `Cena_doba` float NOT NULL,
  `Cena_km` float NOT NULL,
  `Historia_wyp_id` longtext DEFAULT NULL,
  `Zarchiwizowany` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `samochod`
--

INSERT INTO `samochod` (`ID_rejestracja`, `Stan_licznika`, `Model`, `Sprawny`, `W_garazu`, `Cena_doba`, `Cena_km`, `Historia_wyp_id`, `Zarchiwizowany`) VALUES
('DSR4431', 6000, 'Tesla Model S 2017', 1, 1, 300, 0.3, '127, 134, 135', 0),
('KRA9116', 2300, 'BMW M5 F90 2018', 1, 1, 250, 0.3, '128, 131, 139', 0),
('PGS3832', 2000, 'BMW M3 2021', 1, 1, 250, 0.3, '129, 141', 1),
('RJA5847', 202000, 'Nissan Skyline GT-R 2019', 1, 0, 200, 0.3, '130, 132, 138, 140, 143', 0),
('SB34864', 510900, 'Ferrari Portofino 2018 ', 1, 1, 430, 0.4, '137, 142', 0),
('WPI9539', 570742, 'Lamborghini Huracan 2017', 1, 1, 500, 0.5, '136', 0),
('ZMY3674', 194000, 'Koenigsegg Agera RS 2022', 1, 1, 600, 0.5, '133', 0);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `wypozyczenie`
--

CREATE TABLE `wypozyczenie` (
  `ID_wypozyczenia` int(11) UNSIGNED NOT NULL,
  `Osoba_id` bigint(15) UNSIGNED NOT NULL,
  `Rejestracja_id` varchar(50) NOT NULL,
  `Data` date DEFAULT NULL,
  `Licznik_przed` bigint(15) DEFAULT NULL,
  `Data_zwrotu` date DEFAULT NULL,
  `Licznik_po` bigint(15) DEFAULT NULL,
  `Przyjeto_zwrot` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `wypozyczenie`
--

INSERT INTO `wypozyczenie` (`ID_wypozyczenia`, `Osoba_id`, `Rejestracja_id`, `Data`, `Licznik_przed`, `Data_zwrotu`, `Licznik_po`, `Przyjeto_zwrot`) VALUES
(127, 98011931871, 'DSR4431', '2023-06-02', 5000, '2023-06-05', 5800, 1),
(128, 85051654552, 'KRA9116', '2023-06-01', 1451, '2023-06-04', 1800, 1),
(129, 31227922432, 'PGS3832', '2023-06-02', 243, '2023-06-03', 1500, 1),
(130, 52345225323, 'RJA5847', '2023-06-04', 200000, '2023-06-06', 201000, 1),
(131, 85051654552, 'KRA9116', '2023-06-05', 1800, '2023-06-06', 2300, 1),
(132, 52121460047, 'RJA5847', '2023-06-05', 201000, '2023-06-06', 201500, 1),
(136, 31227922432, 'WPI9539', '2023-06-08', 570142, '2023-06-09', 570742, 1),
(137, 34071496132, 'SB34864', '2023-06-09', 509000, '2023-06-09', 510000, 1),
(138, 34071496132, 'RJA5847', '2023-06-07', 201500, '2023-06-08', 202000, 1),
(141, 31227922432, 'PGS3832', '2023-06-02', 1500, '2023-06-03', 2000, 1),
(142, 52345225323, 'SB34864', '2023-06-03', 510000, '2023-06-05', 510900, 1),
(143, 34071496132, 'RJA5847', '2023-06-10', 202000, NULL, NULL, 0);

--
-- Wyzwalacze `wypozyczenie`
--
DELIMITER $$
CREATE TRIGGER `check_car` BEFORE INSERT ON `wypozyczenie` FOR EACH ROW BEGIN
IF ( (SELECT W_garazu from samochod WHERE samochod.ID_rejestracja = new.Rejestracja_id) = 0) THEN
SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'Samochod niedostepny';
ELSEIF ( (SELECT Sprawny from samochod WHERE samochod.ID_rejestracja = new.Rejestracja_id) = 0) THEN
SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'Samochod nie jest sprawny';
ELSEIF ( (SELECT Zarchiwizowany from samochod WHERE samochod.ID_rejestracja = new.Rejestracja_id) = 1) THEN
SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'Samochod jest zarchiwizowany, przywroc go przed wypozyczeniem';
  END IF;
  END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `data_ifnull` BEFORE INSERT ON `wypozyczenie` FOR EACH ROW BEGIN
    IF (NEW.Data IS NULL or NEW.Data<'2000-01-01' ) THEN
        SET NEW.Data = now();
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `delete_rachunek` BEFORE DELETE ON `wypozyczenie` FOR EACH ROW BEGIN
    IF (1) THEN
    SET FOREIGN_KEY_CHECKS=0;
DELETE FROM dodatkowy_koszt
WHERE dodatkowy_koszt.Wypozyczenie_id = old.ID_wypozyczenia;
END IF;
        IF (1) THEN
DELETE from rachunek
WHERE rachunek.Wypozyczenie_id = old.ID_wypozyczenia;
SET FOREIGN_KEY_CHECKS=1;
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `licznik_new` BEFORE INSERT ON `wypozyczenie` FOR EACH ROW SET     new.Licznik_przed = (Select Stan_licznika from samochod WHERE ID_rejestracja = new.Rejestracja_id)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `osoba_historia_update` AFTER INSERT ON `wypozyczenie` FOR EACH ROW BEGIN
IF ((SELECT Historia_wyp_id FROM osoba WHERE osoba.ID_pesel = new.Osoba_id)=NULL or (SELECT Historia_wyp_id FROM osoba WHERE osoba.ID_pesel = new.Osoba_id)='') THEN
UPDATE osoba
SET     osoba.Historia_wyp_id = new.ID_wypozyczenia
WHERE osoba.ID_pesel = new.Osoba_id;
ELSE 
UPDATE osoba
SET     osoba.Historia_wyp_id = CONCAT_WS(", ",osoba.Historia_wyp_id, new.ID_wypozyczenia )
WHERE osoba.ID_pesel = new.Osoba_id;
END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `rachunek_insert` AFTER INSERT ON `wypozyczenie` FOR EACH ROW insert into rachunek(Wypozyczenie_id, Osoba_id, Rejestracja_id, Kilometry, Ilosc_dni) values (new.ID_wypozyczenia, new.Osoba_id,  new.Rejestracja_id,  NULL, NULL)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `rachunek_liczniki_update` AFTER UPDATE ON `wypozyczenie` FOR EACH ROW BEGIN
    IF (NEW.Przyjeto_zwrot = 1 and new.ID_wypozyczenia in (select Wypozyczenie_id from rachunek) ) THEN
UPDATE rachunek
SET Kilometry = new.Licznik_po-new.Licznik_przed, Ilosc_dni = DATEDIFF(new.Data_zwrotu, new.Data)
WHERE Wypozyczenie_id = new.ID_wypozyczenia;
UPDATE samochod
SET Stan_licznika = new.Licznik_po
WHERE ID_rejestracja = new.Rejestracja_id;
ELSE
UPDATE rachunek
SET Kilometry = new.Licznik_po-new.Licznik_przed, Ilosc_dni = DATEDIFF(new.Data_zwrotu, new.Data)
WHERE Wypozyczenie_id = new.ID_wypozyczenia;
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `samochod_historia_update` AFTER INSERT ON `wypozyczenie` FOR EACH ROW BEGIN
IF ((SELECT Historia_wyp_id FROM samochod WHERE samochod.ID_rejestracja = new.Rejestracja_id)=NULL or (SELECT Historia_wyp_id FROM samochod WHERE samochod.ID_rejestracja = new.Rejestracja_id)='') THEN
UPDATE samochod
SET     samochod.Historia_wyp_id = new.ID_wypozyczenia
WHERE samochod.ID_rejestracja = new.Rejestracja_id;
ELSE 
UPDATE samochod
SET     samochod.Historia_wyp_id = CONCAT_WS(", ",samochod.Historia_wyp_id, new.ID_wypozyczenia )
WHERE samochod.ID_rejestracja = new.Rejestracja_id;
END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `wypozycz_new` AFTER INSERT ON `wypozyczenie` FOR EACH ROW UPDATE samochod
SET     samochod.W_garazu = 0
WHERE samochod.ID_rejestracja = new.Rejestracja_id
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `zwrot_update` BEFORE UPDATE ON `wypozyczenie` FOR EACH ROW BEGIN
    IF (NEW.Data_zwrotu IS NOT NULL and NEW.Licznik_po IS NOT NULL and NEW.Licznik_po >= NEW.Licznik_przed and NEW.Data_zwrotu >= NEW.Data  ) THEN
        SET NEW.Przyjeto_zwrot = 1;
        UPDATE samochod
SET     samochod.W_garazu = 1
WHERE samochod.ID_rejestracja = new.Rejestracja_id;
ELSE
SET NEW.Przyjeto_zwrot = 0;
    END IF;
END
$$
DELIMITER ;

--
-- Indeksy dla zrzutów tabel
--

--
-- Indeksy dla tabeli `dodatkowy_koszt`
--
ALTER TABLE `dodatkowy_koszt`
  ADD UNIQUE KEY `Wypozyczenie_id_2` (`Wypozyczenie_id`),
  ADD KEY `Wypozyczenie_id` (`Wypozyczenie_id`);

--
-- Indeksy dla tabeli `osoba`
--
ALTER TABLE `osoba`
  ADD PRIMARY KEY (`ID_pesel`),
  ADD UNIQUE KEY `ID_pesel` (`ID_pesel`);

--
-- Indeksy dla tabeli `rachunek`
--
ALTER TABLE `rachunek`
  ADD UNIQUE KEY `Wypozyczenie_id_2` (`Wypozyczenie_id`),
  ADD KEY `Wypozyczenie_id` (`Wypozyczenie_id`),
  ADD KEY `Rejestracja_id` (`Rejestracja_id`),
  ADD KEY `Osoba_id` (`Osoba_id`);

--
-- Indeksy dla tabeli `samochod`
--
ALTER TABLE `samochod`
  ADD PRIMARY KEY (`ID_rejestracja`),
  ADD UNIQUE KEY `ID_rejestracja` (`ID_rejestracja`);

--
-- Indeksy dla tabeli `wypozyczenie`
--
ALTER TABLE `wypozyczenie`
  ADD PRIMARY KEY (`ID_wypozyczenia`),
  ADD UNIQUE KEY `ID_wypozyczenia` (`ID_wypozyczenia`),
  ADD KEY `Osoba_id` (`Osoba_id`),
  ADD KEY `Rejestracja_id` (`Rejestracja_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `wypozyczenie`
--
ALTER TABLE `wypozyczenie`
  MODIFY `ID_wypozyczenia` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=144;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `dodatkowy_koszt`
--
ALTER TABLE `dodatkowy_koszt`
  ADD CONSTRAINT `dodatkowy_koszt_ibfk_1` FOREIGN KEY (`Wypozyczenie_id`) REFERENCES `rachunek` (`Wypozyczenie_id`);

--
-- Constraints for table `rachunek`
--
ALTER TABLE `rachunek`
  ADD CONSTRAINT `rachunek_ibfk_1` FOREIGN KEY (`Wypozyczenie_id`) REFERENCES `wypozyczenie` (`ID_wypozyczenia`),
  ADD CONSTRAINT `rachunek_ibfk_3` FOREIGN KEY (`Rejestracja_id`) REFERENCES `wypozyczenie` (`Rejestracja_id`),
  ADD CONSTRAINT `rachunek_ibfk_4` FOREIGN KEY (`Osoba_id`) REFERENCES `wypozyczenie` (`Osoba_id`);

--
-- Constraints for table `wypozyczenie`
--
ALTER TABLE `wypozyczenie`
  ADD CONSTRAINT `wypozyczenie_ibfk_2` FOREIGN KEY (`Rejestracja_id`) REFERENCES `samochod` (`ID_rejestracja`),
  ADD CONSTRAINT `wypozyczenie_ibfk_3` FOREIGN KEY (`Osoba_id`) REFERENCES `osoba` (`ID_pesel`);
COMMIT;

--
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;