![](./images/dbt_foundation.jpg)

## What is `dbt`?
`dbt` (data build tool) is a tool that allows you to easily build and maintain data pipelines and data warehouses. Recently it gained more and more popularity as it bridges the gap between data engineering and data analytics and subsequently enabling the emergence of analytics engineering as a field.

There are two major data integration processes used in data pipelines, called *ETL* and *ELT*. The key difference between both lies in the order of operations. 

- In **ETL**, the data is first extracted from the source system, then transformed and finally loaded into the data warehouse. 
- While in **ELT**, the data is extracted from the source system, loaded into the data warehouse and transformed afterwards. So in contrast to ETL, upon arrival in the data warehouse, the data is still raw. 

`dbt` is commonly used in the transformation part of **ELT** because it facilitates the creation and maintenance of data transformations in a way that is testable and version controlled. Hence it allows you to transform and analyze your data in a structured and documentable way, while tailoring it to your client's needs.

## Why `dbt`?
There are a lot of reasons why you should use `dbt` where some of them are mentioned below:
- It is open source and free to use
- It is very easy to *use*. You can start using it in a few minutes
- It is very easy to *test*. You can easily test your models
- It is very easy to *document*. You can easily document your models
- It is very easy to *version control*. You can easily version control your models
- It is very easy to *deploy*. You can easily deploy your models to different environments
- It is very easy to *automate*. You can easily automate your models
- It is very easy to *integrate*. You can easily integrate it with other tools
- It is very easy to *maintain*. You can easily maintain your models

## How does `dbt` work?
`dbt` is basically adding a modeling layer to the data warehouse. We get the raw data and run it through dbt models. Each dbt model is a `.sql` file which is depending either on the raw data or on other dbt models. The output of the dbt models is then stored in the data warehouse as views or tables.

In a standard `dbt` project you have the following layers:

- raw data
- staging models: where you can clean the data (rename columns, remove duplicates, etc.)
- prep models: where you can aggregate the data (sum, count, etc.)
- analysis models or mart models: where you can analyze the data (calculate the average, etc.)

These mart models often are seperated by stakeholder groups. So you have mart models for the marketing team, mart models for the sales team, etc. and they are organized in different folders and in different schemas within the data warehouse.

## `dbt` repositories

One of the `dbt` aims is to create a flow where your work will be **version controlled**. That's why all the code that `dbt` will need to model the data has to be a part of a repository. You will need to create a new repository in your GitHub that will follow this structure:
- `dbt_project.yml` - defines the project and global variables/paths
- `dbt_packages` - used if any external packages are used (same like pandas in python)
- `logs` - logs of all `dbt` runs
- `macros` - will store the code that might be repeated (like a function in python)
- `models`:
   - `staging` — creating our atoms, our initial modular building blocks, from source data
   - `prep` (intermediate) — stacking layers of logic with clear and specific purposes to prepare our staging models to join into the entities we want 
   - `marts` — bringing together our modular pieces into a wide, rich vision of the entities our organization cares about - for the stakeholers
- `seeds` — seeds are CSV files in your `dbt` project (typically in your seeds directory), that `dbt` can load into your data warehouse using the `dbt seed` command
- `snapshots` — analysts often need to "look back in time" at previous data states in their mutable tables. While some source data systems are built in a way that makes accessing historical data possible, this is not always the case. `dbt` provides a mechanism, snapshots, which records changes to a mutable table over time
- `target` — where the compiled SQL code is saved
- `tests` — tests are assertions you make about your models and other resources in your `dbt` project (e.g. sources, seeds and snapshots). When you run `dbt test`, `dbt` will tell you if each test in your project passes or fails.

## `dbt core` and `dbt cloud`
There are two ways of using `dbt`. 
1. **dbt Core:** An open-source project. It’s free to use, but it requires technical knowledge as you have to set it up locally on your computer.
2. **dbt Cloud:** A commercial product. `dbt cloud` is basically `dbt` core with a lot of additional out-of-the-box features like job orchestration, which you would have to do on your own in the open-source version.  
   

In our week we will use the beginner-friendly `dbt cloud`.

## 1. Create a Git Repository

We will need a repository with the codebase for data modeling / data pipeline:

<table class="bdrless" style="border-width: 0px">
   <tr>
    <td><b>0.</b></td>
    <td>Create a new Repository in your personal GitHub account. Click the link here on the right, or go to GitHub to your repositories and click the green button "New". Call it something like "dbt_meteostat". For</td>
    <td><a href="https://github.com/new">Create a new GitHub Repo</a></td>
   </tr>
</table>



## 2. Setup dbt Cloud 

### dbt cloud account with initial configuration

<table class="bdrless" style="border-width: 0px">
   <tr>
    <td><b>1.</b></td>
    <td>Go to dbt cloud sign up page</td>
    <td><a href="https://www.getdbt.com/signup/">dbt cloud sign up page</a></td>
   </tr>
   <tr>
    <td><b>2.</b></td>
    <td>Provide all the information needed to create an account and click on <b>Create my account</b></td>
    <td><a href="./images/dbt_setup_1.png" target="_blank"><img src="./images/dbt_setup_1.png" style="zoom:20%;" /></a></td>
   </tr>
   <tr>
    <td><b>3.</b></td>
    <td>Make sure you click on the verification email</td>
    <td><a href="./images/dbt_setup_2.png" target="_blank"><img src="./images/dbt_setup_2.png" style="zoom:20%;" /></td>
   </tr>  
   <tr>
    <td><b>4.</b></td>
    <td>As we already have a database ready, select the <b>I have a data warehouse</b> option</td>
    <td><a href="./images/dbt_setup_3.png" target="_blank"><img src="./images/dbt_setup_3.png" style="zoom:20%;" /></td>
   </tr>   
   <tr>
    <td><b>5.</b></td>
    <td>Choose <b>PostgreSQL</b> and click on <b>Next</b></td>
    <td><a href="./images/dbt_setup_4.png" target="_blank"><img src="./images/dbt_setup_4.png" style="zoom:20%;" /></td>
   </tr> 
   <tr>
    <td><b>6.</b></td>
    <td>Provide the database credentials: host, port and database name (that's the new database that you've just created)</td>
    <td><a href="./images/dbt_setup_5.png" target="_blank"><img src="./images/dbt_setup_5.png" style="zoom:20%;" /></td>
   </tr> 
   <tr>
    <td><b>7.</b></td>
    <td>Under <b>Development Credentials</b> provide your credentials including username (should be <b>postgres</b>), password to the instance and the schema that should be set to <b>public</b></td>
    <td><a href="./images/dbt_setup_7.png" target="_blank"><img src="./images/dbt_setup_7.png" style="zoom:20%;" /></td>
   </tr>
   <tr>
    <td><b>8.</b></td>
    <td>Test your database connection!</td>
    <td><a href="./images/dbt_setup_8.png" target="_blank"><img src="./images/dbt_setup_8.png" style="zoom:20%;" /></td>
   </tr>
   <tr>
    <td><b>9a.</b></td>
    <td><b>Setup a repository (Option A):</b> <br>
    The easiest way is to allow dbt to securely login to your github. 
      <li>choose "Github" option</li>
      <li>a popup will ask you to login</li>
      <li>and then choose the dbt-starter-repo</li>
      <li>THEN YOU CAN SKIP TO STEP 16</li>
      </td>
    <td><a href="./images/dbt_setup_9a.png" target="_blank"><img src="./images/dbt_setup_9a.png" style="zoom:20%;" /></td>
   </tr>
   <tr>
    <td><b>9b.</b></td>
    <td><b>Setup a repository (Option B):</b> <br>
    dbt can also get access to a github repo using ssh key
    <li>choose "Git Clone" option</li>   
    <li>follow the steps 10-15</li>
    </td>
    <td><a href="./images/dbt_setup_9b.png" target="_blank"><img src="./images/dbt_setup_9b.png" style="zoom:20%;" /></td>
   </tr>
   <tr>
    <td><b>10.</b></td>
    <td>Copy the ssh connection and the link taken from your repository (check it on github.com) under the <b>Code</b> button.</td>
    <td><a href="./images/dbt_setup_10.png" target="_blank"><img src="./images/dbt_setup_10.png" style="zoom:20%;" /></td>
   </tr>
   <tr>
    <td><b>11.</b></td>
    <td>Paste the link to dbt setup. It will generate an ssh key. You need to add to the repo on github.com.
    <li>Copy the ssh-rsa key</li>
    <li><a href="https://docs.getdbt.com/docs/cloud/git/import-a-project-by-git-url">tutorial</a></td>
    <td><a href="./images/dbt_setup_11.png" target="_blank"><img src="./images/dbt_setup_11.png" style="zoom:20%;" /></td>
   </tr>
   <tr>
    <td><b>12.</b></td>
    <td>In your GitHub:  
    - click on your image in the top right corner, choose <b>Settings</b> from the menu
    - from the menu on the left select <b>SSH and GPG keys</b>
    - click the green button "New SSH Key"
   </td>
    <td><a href="./images/dbt_setup_12.png" target="_blank"><img src="./images/dbt_setup_12.png" style="zoom:20%;" /></td>
   </tr>
   <tr>
    <td><b>13.</b></td>
    <td>In your GitHub:
    <ul>
      <li>Give the key a name(e.g. 'dbt-weather')</li>
      <li>paste the ssh key from dbt and save it</li>
      <li>a prompt will ask you to confirm with your GitHub password</li>
   </ul>
   </td>
    <td><a href="./images/dbt_setup_13.png" target="_blank"><img src="./images/dbt_setup_13.png" style="zoom:20%;" /></td>
   </tr>
   <tr>
    <td><b>14.</b></td>
    <td>In your GitHub: you should now see the ssh key
   </td>
    <td><a href="./images/dbt_setup_14.png" target="_blank"><img src="./images/dbt_setup_14.png" style="zoom:20%;" /></td>
   </tr>
   <tr>
    <td><b>15.</b></td>
    <td>Back to dbt repository setup. Click the Button "Next". If everything worked you might see a similar message...</td>
    <td><a href="./images/dbt_setup_15.png" target="_blank"><img src="./images/dbt_setup_15.png" style="zoom:20%;" /></td>
   </tr>
   <tr>
    <td><b>16.</b></td>
    <td>... and your dbt project is ready!</td>
    <td><a href="./images/dbt_setup_16.png" target="_blank"><img src="./images/dbt_setup_16.png" style="zoom:20%;" /></td>
   </tr>
   <tr>
    <td><b>17.</b></td>
    <td>Go to your <b>Account Settings</b> (using the icon in the top right corner) and go to the <b>Billing</b> section from the menu on the left side. Make sure you're using the developer plan which is free of charge and allows you to have one project at a time </td>
    <td><a href="./images/dbt_setup_17.png" target="_blank"><img src="./images/dbt_setup_17.png" style="zoom:20%;" /></td>
   </tr>   
   <tr>
    <td><b>18.</b></td>
    <td>In the navigation bar go to <b>Initialize dbt project</b> It will create all the necessary folders. dbt will synchronise with GitHub and show the repo on the left under "File Explorer". Above that is the Version Control Section.<br><b>Note: We <u>don't need</u> to create a branch.</b></td>
    <td><a href="./images/dbt_setup_18.png" target="_blank"><img src="./images/dbt_setup_18.png" style="zoom:20%;" /></td>
   </tr>
</table>





### Reading

- [How to strucure a dbt project](https://docs.getdbt.com/guides/best-practices/how-we-structure/1-guide-overview)
- [About data transformations](https://www.getdbt.com/analytics-engineering/transformation/)
