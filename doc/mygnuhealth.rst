===============
 |MyGNUHealth|
===============


.. Note:: This document is licensed under Creative Commons 
    Attribution-ShareAlike 4.0 International (CC BY-SA 4.0) 

:Author: Luis Falcon
:Contact: info@gnuhealth.org
:Version: 0.9b3

.. contents::


Introduction
============
MyGNUHealth is the GNU Health Libre **Personal Health Record**. This application can
be used in desktops and mobile devices.

MyGNUHealth is a desktop and mobile application that helps you to take 
control of your health. As a Personal Health Record, you will be able to assess, 
record and take action upon the determinants of the main health spheres 
(bio-psycho-social).

MyGNUHealth will be your health companion. You will be able to connect with your
health professionals, and share the health data you wish to share with them in
real time.

MyGNUHealth puts you in the driver's seat, as an active member of the system of
health.


The need of a Libre Personal Health Record
------------------------------------------
A Personal Health Record must respect the freedom and privacy of the individual.

There are Personal Health Record applications in the market, but MyGNUHealth is
unique. MyGNUHealth is a Libre program respects your freedom and privacy. By
Libre we mean that the source code of the application is available; the user can
modify it if she wishes, and interact with the community to improve the application.
You are in control of the application. Unlike other closed-source health applications,
you can rest assured that your health information won't be leaked or sold to anyone.

MyGNUHealth is part of the GNU Health ecosystem (https://www.gnuhealth.org),
a project that uses state-of-the-art technology to deliver Social Medicine, equity,
freedom and privacy in healthcare.

MyGNUHealth is licensed under the **GNU General Public License v3+**. It is Libre,
and it will remain Libre.

Downloading and installing the application
==========================================

MyGNUHealth will be available from different sources. Check if your operating
system already has the MyGNUHealth package.

MyGNUHealth depends on both Kirigami2 and PySide2 to be installed at a system
level, and will not properly work otherwise.
Using the system's package manager will be enough to install those dependencies
keeping in mind the required versions on the system:

* PySide2 5.15+
* Python 3.6+

After installing those dependencies on the system,
you can install MyGNUHealth via pip::

 $ pip install --user --upgrade MyGNUHealth

(Keep in mind some systems might have `pip3` instead of `pip`)


Using MyGNUHealth
=================

Starting up the application
---------------------------

Click or tap into the MyGNUHealth icon on your mobile device or desktop.
You will be presented with the welcoming screen.


Profile initialization
----------------------
The very first time MyGNUHealth is run, you need to enter very basic
information about yourself. The date of birth, height and sex are the
main parameters to be included. They are used in medical contexts, so
is important that you fill them in. In this step, you will also create
your **personal key**

.. list-table::

    * - |InitialScreen|
        Initial Page
      - |ProfileInitialization|
        Profile Initialization

The button to create the profile will activate when the following requirements
are met:

* The height value is set
* The personal key is 4 characters or longer
* The personal key is entered twice correctly

Navigation
----------
MyGNUHealth uses a "stack" navigation model. That is, when you enter a
page, you move forward, and do a "push" operation on it. The opposite 
also applies. When moving backwards, you do a "pop" operation on the
current page, and move back one level.

Signing into MyGNUHealth
-------------------------
|LoginScreen|


The main screen
---------------
|MainScreen|

Once you sign in, you are presented to the MyGNUHealth main screen, with the 
main components:

* **Health Tracker**: This section records quantifiable events,
  from the biological, lifestyle and psychological domains.
     
* **Book of Life**: The book of life is your personal health diary, made of 
  *Pages of Life*. From the genetic and molecular components, to the social
  events throughout your life that make you a unique individual.

.. note:: The main screen components and layout might change from one release
    to another.


The Menu (Drawer)
-----------------
|Menu| 

You will find the main menu on the upper left corner. 
The main entries are:

* Profile Settings: Updates your user information and 
* Network Settings: Tests the connection to the GNU Health Federation
* Logout: Sign out from MyGNUHealth and takes you to the initial screen.
* About page: Displays the **version** and credits.


|MenuActive|

Most of the items, except the "About" entry can only be accesible once 
you have logged into the application. Inactive entries are in grey.


Once you signed it, all the menu entries are enabled, as you can see from the
previous image.

Profile Settings
~~~~~~~~~~~~~~~~
In the profile settings page you can set or update the information related to
your height, Federation account (if you have one) and update your personal
key (password).

|ProfileSettings|

It's important that you set your **height**. It will be used to calculate your
current Body Mass Index (BMI) any time you enter your weight in the health
tracker.

The height is shown in centimeters, so "178" corresponds to "1.78 m"

The **Federation account** is a unique ID that identifies you within a 
*GNU Health Federation* . If your country, province or health professional are
part of the GNU Health Federation, then you can share information with them
in real time.
The GNU Health Federation is revolutionary. It connects individuals with their
health professionals, health institutions, laboratories, research institutions,
social services and other entities related to the system of health.


Network Settings (Federation)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
MyGNUHealth can work in an autonomous way, that is, without sharing information, or
integrated in the **GNU Health Federation**.
If you choose to integrate yourself with the system of health and your healthcare
professionals, then MyGNUHealth will be able to share the information that with them.

|NetworkSettings|

Your health center will provide you with all the required information to integrate to
the GNU Health Federation. The information required is:

* Thalamus server Information : protocol, server name and port
* Federation Account: An account that uniquely identifies you in the Federation.
* Account password
* Enable Federation Synchronization (optional): If you set this option, you will
    be able to push the pages of life to the GNU Health Federation.


Once you have entered all the information, you can test the network and credentials by
pressing the "Test connection" button.

.. list-table::

    * - |ConnectionOK|
        Connection test OK
      - |InvalidCredentials|
        Wrong Credentials
      - |ConnectionError|
        Network Error


.. Note:: The user name (Federation account) and the password are not stored.
    They just serve as a way to test the connection to Thalamus. If you have
    a definitive federation account, you can store in on your user profile.

Once you are ready, you can press the "Update" button to save the network information.


Logout
~~~~~~

The logout action closes all the pages, signs you out from MyGNUHealth and takes you to the
initial screen.

The About page
~~~~~~~~~~~~~~
The about page gives you license information, credits and the **version**.
Knowing the version is important so you can report issues or know the latest functionality.

|About|


Data directory and backup
-------------------------
MyGNUHealth profile and databases are stored in your home directory, under **"mygh"**.
You can backup that directory.


The Health Tracker
==================
As we mentioned in the introduction, MyGNUHealth has two main sections, the Health tracker
and the book of life.

The Health Tracker currently has three main blocks:

* Bio: This section focuses on monitoring common physiological and
  anthropometric parameters of medical importance, such as blood pressure,
  heart rate, glucose level or weight.
* Lifestyle: The section covers basic lifesytle patterns. Eating habits and calorie intake,
  sleep and physical activity.
* Psychological assessment: A basic self-assessment of mood and energy levels.

.. figure:: ./images/mygnuhealth_wide_bio.png

   Workflow from the main PHR page to the Blood pressure history

   When you are using MyGNUHealth desktop client, you can resize the application, so the
   you can have two or three pages on the same screen. In this example, clicking on
   the "Health Tracker" section, it will show the three main areas (Bio, lifestyle and
   pyschological assessment). If you select the bio section, MyGNUHealth will present
   the contexts (Blood pressure, glucose level...) that make up the "Bio" page.

.. Note:: In upcoming versions, MyGNUHealth will support for smartwatches, such as the
    *PineTime*, glucometers, oximeters and other devices that are open hardware and use
    open protocols.


Health tracker cards
--------------------

The different contexts within the health tracker are encapsulated into items called
"cards". The layout and contents of the cards contain a descriptive icon, a title and the
last reading (date and values). In the lower corners of the cards there are two icons, one
for the **chart** and in the lower right corner one to **add** a new entry.

|BloodPressureCard|

All health tracker cards share the same layout.

Bio / clinical assessment
-------------------------

* Blood pressure
* Heart rate: The heart frequency is recorded in the same card as the blood pressure, since
  many BP monitors measure both parameters.
* Blood glucose level (mg/dL)
* Weight: The Unit of measure is in kilograms
* Hemoglobin (Hb) oxygen saturation (Osat)

.. Note:: You can take as many measures as you need during the day. It is normal for
    some parameters to be taken several times during the day, like in the case of glucose.
    However, there are some parameters that usually are taken once a day (i.e., weight).

Lifestyle
---------

|LifeStyleSummary|

* Physical Activity

 * Steps
 * Aerobic and anaerobic activity (minutes)

* Nutrition: Total Kcal per day divided in morning, afternoon and night.
* Sleep: Records the number of hours and quality of the sleep.


Psychological self assessment
-----------------------------
MyGNUHealth allows you to keep a log of your **mood and energy levels**, either on a daily basis
or different times during a day.
Keeping track of how you feel about your mood and energy provides a great deal of
information to your health professional.

Please also provide your **sleep** patterns (see lifestyle section) that complements this
mood and energy tracker.


The mood and energy meters
~~~~~~~~~~~~~~~~~~~~~~~~~~
The mood and enery meters are *sliders* situated on the left side of the page. In oder to
register a new entry, you need to activate (click on the slider) and set the current level.

On the center of the page, there are two emoticons, that change depending on the mood and
energy levels.

|MoodEnergyAssessment|

**Mood levels**: The mood level has the **[-3:3] range**. Frequent values on the extremes
(extremely happy (+3) or extremely sad (-3)) could be associated to mood disorders.

**Energy level**: The energy level is represented by the battery emoticon, and the interval
has a **range from 0 to 3** [0:3]. Zero being exhausted and 3 supercharged. As in the the case of
mood levels, frequent values on the extreme might be a warning sign of a mood disorder or
other medical condition.

.. Note:: It is your **health professional** who will make the best reading out of this and
    other logs from MyGNUHealth. Please consult with her. She will be able to **interpret**
    the recordings in a much broader context, with your help and other domains and readings
    from MyGNUHealth.


A note on charts
----------------
MyGNUHealth, thanks to the excellent *matplotlib* package, has the ability to automatically
set the x axis (time) value. You will notice, specially when there are few records, that the
x-axis will show values in the unit of hours (time of the day) and days. That is the expected
behaviour.

The Book of Life
================

The other major section on MyGNUHealth is the **Book of Life** (BoL). Think about
it as a health dairy, where you can register any event that happens in your
lifetime, and that it can have an impact in your health and wellbeing. Each entry
in the BoL is called a **Page of Life**. A difference with a traditional diary is
that in MyGNUHealth, you can have many pages of life per day.

In the previous chapters and section, we covered the Personal Health Record (PHR).
Anytime you register a new reading on your bloood pressure, steps, calories,
mood, etc.. MyGNUHealth generates an associated Page of Life entry.

|BookOfLifeList|

.. Note:: If you have configured MyGNUhealth to be part of the GNU Health Federation,
    the password field next to the "Create a new page" icon will be enabled

Creating a new Page of Life
---------------------------
At the top of the book of life you will find to widgets:

* New Page Icon
* GNU Health Federation account password: Enabled only if you have such user
  and specify to sync

Click on the New Page icon and you will be able to create a new page.

Structure of a Page of Life
~~~~~~~~~~~~~~~~~~~~~~~~~~~
A new Page of Life is created by clicking on the top

|PageofLifeFields|

Domains and contexts
~~~~~~~~~~~~~~~~~~~~

As we just mentioned, the **basic unit of information** in MyGNUHealth
is the **Page of Life**, and corresponds to relevant event.
To facilitate data gathering and information processing, each page of life has
a category (**domain**), and each domain has several sections (**contexts**).

At the moment that you choose a particular domain, the context selection field
automatically sets the list of contexts associated to that domain.

.. list-table:: Health domains and their contexts
    :header-rows: 1

    * - Domain
      - Contexts
    * - **Medical**
      - Health condition, encounter, procedure, **Self monitoring**, Immunizaton, Prescription,
        Surgery, Hospitalization, Lab test, Dx Imaging, Genetics, Family History
    * - **Social** [#who]_
      - Social Gradient, Early life development, Stress, Social exclusion, Working conditions,
        Education, Physical environment, Unemployement, Social Support, Addiction, Food,
        Transportation, Health services, Family functionality, Family violence, Bullying, War,
        Misc
    * - **Lifesyle**
      - Physical activity, Nutrition, Sleep
    * - **Biographical**
      - Birth, Death, Misc
    * - **Other**
      - Misc



The Medical Genetics context
~~~~~~~~~~~~~~~~~~~~~~~~~~~~
The structucture of a Page of Life is constant for all domains and
contexts, with the **exception** of the *Medical Genetics* context.

Thanks to **UniProt** [#uniprot]_, MyGNUHealth provides an up-to-date dataset
of over 31000 natural variants and genetic conditions.

In this context, you can enter any sort of information related to genetics.
The natural variants / mutations are one of them.

.. list-table::

    * - |MedicalGeneticsFields|
         Medical genetics fields
      - |NaturalVariantExample|
         RefSNP example on MyGNUHealth


**Example on Cystic Fibrosis**

The example will help to better understand how to create a Medical Genetics
page of life.
A health professional, after the evaluation of a patient, is suspicious about
the clinical signs being compatible with cystic fibrosis and orders a genetic
test to confirm.
A genetic test was performed on the Cystic Fibrosis Transmembrane Conductance
Regulator (**CFTR**) gene.
The molecular test on CFTR gene confirmed the clinical suspicion of the
health professional, with this result:

* RefSNP (rs): rs397508635
* Gene: CFTR
* Aminoacid (AA) change: p.Ser13Phe
* Natural variant: VAR_000101
* Protein ID: P13569
* Significance: LP/P
* Disease: Cystic fibrosis (CF) [MIM:219700]

**Discussion**
MyGNUHealth only requires the **RefSNP ("rs") id** related to the natural variant.
Once the rsid is entered, the rest of the fields are automatically filled. In fact
the rest of the fields related to the RefSNP are **read-only**.

**Gene**: The gene associated to that natural variant (eg, P13569)
**AA Change**: The aminoacid change and position (eg, p.Ser13Phe)
**Natural variant**: The specific variant ID are related to the refSNP.
**Protein ID**: The UniprotKB protein ID (eg, P13569)
**Significance**: The clinical significance of the protein natural variant can have the
following values:

* **LB/B**: Likely benign or benign
* **LP/P**: Likely pathogenic or pathogenic
* **US**: Unknown significance

**Disease**: If the natural variant is pathogenic, MyGHNUHealth will also display the
associated disease(s). Along with the disease name, the MIM code is included in
brackets (eg, [MIM:219700]).

**Details textbox**: The last relevant field is the "details" textbox. In this text area
you can enter extra information about the variant or genetic condition in
your personal experience. Information about age of onset, family history, clinical
manifestations, etc..

**Getting more information about a protein and variants**
There are different ways to get more information about an specific variant.
If we know the protein ID, one good approach is to search for it at **UniProtKB**.
In this example, we would look for "P13569".
Look at the section "*Involvement in disease*".
The MIM code is part of the Online Mendelian Inheritance in Man (OMIM) database [#omim]_. You
can get the latest information on that by entering the code (eg, 219700)

A call for Open Science
=======================
Science can not evolve if the information is kept in private hands. If we, as a
society and as a scientific community want to find solutions for neurodegerative
diseases, cancer, metabolic and genetic disorders, we need open science.

GNU Health is the Libre Digital Health ecosystem [#gnuhealth]_. It has several
components, such as a Hospital Management Information System (HMIS), a Lab Information
System (LIMS), and the Personal Health Record (MyGNUHealth), among others. One of
our goals is to deliver universality in health informatics.

All these components can interact with each other through the GNU Health Federation.
The GNU Health Federation links patients, health professionals and researchers.

MyGNUHealth is a unique Personal Health Care, because it combines the socioeconomic
determinants of health with the molecular basis of disease. The environment plays
a crucial role in many of today's most devastating and elusive diseases.
MyGNUHealth and the GNU Health Federation open a fantastic opportunity
in the areas of epigenetics and precision medicine. There are still many
genetic variants of unknown significance.

The GNU Health ecosystem and its international community provide the key for
boosting the research in bioinformatics, social medicine and public health. We need
our governments to use Free/Libre software in the public administration, particularly,
in the education and public health systems.

The need for a Kinder Science
=============================
Last but not least, we need to work on human-relevant, animal free research.
Science can not be complicit of the enslaving, torture and killing of millions of
innocent beings in laboratories around the world.
Speciesism and any other type of discrimination (racism, sexism,..) are appalling and
must be abolished.
In 2020 I signed with other scientists an open letter lead by Animal Free Research
UK, a call to accelerate human-focussed medical research [#kinderscience]_. Today there
are safer, effective and cruelty free alternatives. Let's embrace them.



Contact and suggestions
=======================
You can contact us at info@gnuhealth.org

To report bugs, please subscribe to the general GNU Health mailing list
(https://lists.gnu.org/mailman/listinfo/health)

.. rubric:: Footnotes
.. [#who] Many of the Social contexts are from the World Health Organization social determinants of
         health.
.. [#uniprot] The Unitprot Consortium - https://www.uniprot.org
.. [#omim] Online Mendelian Inheritance in Man - https://www.omim.org
.. [#gnuhealth] The Libre Digital Health ecosystem - https://www.gnuhealth.org
.. [#kinderscience] A call to accelerate human-focussed medical research
                    https://www.animalfreeresearchuk.org/openletter/

.. |InitialScreen| image:: ./images/initial_screen.png
.. |MainScreen| image:: ./images/main_screen.png
.. |ProfileInitialization| image:: ./images/user_profile_initialization.png
.. |MyGNUHealth| image:: ./images/mygnuhealth.png
.. |LoginScreen| image:: ./images/login_screen.png
.. |Menu| image:: ./images/menu_global_drawer.png
.. |MenuActive| image:: ./images/menu_global_drawer_active.png
.. |ProfileSettings| image:: ./images/profile_settings.png
.. |NetworkSettings| image:: ./images/network_settings.png
.. |ConnectionOK| image:: ./images/test_connection_success.png
                           :width: 80%
.. |ConnectionError| image:: ./images/test_connection_error.png
                           :width: 80%
.. |InvalidCredentials| image:: ./images/test_connection_invalid.png
                           :width: 80%
.. |BloodPressureCard| image:: ./images/blood_pressure_card.png
.. |LifeStyleSummary| image:: ./images/lifestyle_summary.png
.. |MoodEnergyAssessment| image:: ./images/mood_and_energy_assessment.png
.. |BookOfLifeList| image:: ./images/book_of_life_list.png
.. |PageofLifeFields| image:: ./images/page_of_life_fields.png
.. |MedicalGeneticsFields| image:: ./images/medical_genetics_fields.png
.. |NaturalVariantExample| image:: ./images/natural_variant_example.png
.. |About| image:: ./images/about.png

