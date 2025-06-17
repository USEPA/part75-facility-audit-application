# Part 75 Facility Audit Application

This application is built to be a tool for part 75 analysts.

---

## Table of Contents

- [Cloning the Repository](#cloning-the-repository)
- [Working with Branches](#working-with-branches)
- [Making Changes and Pull Requests](#making-changes-and-pull-requests)
- [Running the Application Locally](#running-the-application-locally)
- [Pushing Changes and Updating the Manifest](#pushing-changes-and-updating-the-manifest)
- [Deploying to Posit Connect](#deploying-to-posit-connect)
- [Helpful Resources](#helpful-resources)

---

## Cloning the Repository

To get a copy of this project on your computer:

1. **Install Git** if you haven't already: [Git Download](https://git-scm.com/downloads)
2. Open **Git Bash** or your terminal.
3. Navigate to the folder where you want to save the project:
    ```bash
    cd /path/to/your/directory
    ```
4. Clone the repository:
    ```bash
    git clone https://github.com/USEPA/part75-facility-audit-application.git
    ```

---

## Working with Branches

**Branches** let you work on changes without affecting the main code.  
**Never push directly to the `main` branch.** Always create a new branch for your work.

### How to Create a Branch in RStudio

1. Open the project in RStudio.
2. Go to the **Git** tab (usually in the top right).
3. Click the "Branch" button (or use the menu: *Git > New Branch*).
4. Name your branch (e.g., `feature-yourname-description`).
5. Click "Create".

More details: [RStudio Version Control Documentation](https://docs.posit.co/ide/user/ide/guide/tools/version-control.html)

---

## Making Changes and Pull Requests

1. **Make your changes** in your branch.
2. **Commit** your changes:
    - In RStudio, go to the **Git** tab, check the files you changed, write a message, and click "Commit".
3. **Push** your branch to GitHub:
    - Click "Push" in the Git tab.
4. **Create a Pull Request**:
    - Go to the [GitHub repository](https://github.com/USEPA/part75-facility-audit-application).
    - Click "Compare & pull request" next to your branch.
    - Add a description of your changes.
    - Click "Create pull request".

A pull request lets others review your changes before they are added to the main branch.

---

## Running the Application Locally

After cloning the repository:

1. Open the project folder in **RStudio**.
2. Install required R packages (only once):
    ```r
    install.packages(c("shiny", "shinydashboard", "dplyr", "ggplot2", "DT"))
    ```
3. Run the application:
    - Click the **"Run App"** button in RStudio,  
      **or**
    - In the R console, type:
      ```r
      shiny::runApp()
      ```

---

## Pushing Changes and Updating the Manifest

The application is deployed from the `main` branch.  
**You must update the manifest file if you change the app.**

1. Install the `rsconnect` package (if needed):
    ```r
    install.packages("rsconnect")
    ```
2. Load the package:
    ```r
    library(rsconnect)
    ```
3. Update the manifest file:
    ```r
    rsconnect::writeManifest()
    ```
4. Commit and push your changes (see above).

---

## Deploying to Posit Connect

- The app is **automatically deployed** to Posit Connect when changes are merged into the `main` branch.
- Always create a pull request for review before merging.
- The app is hosted at:  
  <https://rstudio-connect.dmap-stage.aws.epa.gov/connect/#/apps/1c1cf2f3-70f6-445c-a40d-2372372b0f11>

---

## Helpful Resources

- [GitHub Hello World Guide](https://docs.github.com/en/get-started/quickstart/hello-world)
- [RStudio Version Control Documentation](https://docs.posit.co/ide/user/ide/guide/tools/version-control.html)
- [Happy Git and GitHub for the useR](https://happygitwithr.com/)
- [Shiny Tutorials](https://shiny.posit.co/tutorial/)

---

*If you have questions, ask your team or check the resources above!*