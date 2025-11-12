# Load required libraries
library(ellmer)       # For interacting with OpenAI's API
library(shinychat)    # Provides chat UI components for Shiny
library(shiny)        # Core Shiny framework
library(bslib)        # Enables Bootstrap theming and styling
library(bsicons)      # For using Bootstrap icons
library(htmltools)    # For HTML utilities in UI
library(httr2)        # For HTTP requests and responses
library(purrr)        # For functional programming utilities
library(glue)         # For string interpolation and templating


# ----------------------------
# USER INTERFACE (UI) SECTION
# ----------------------------
ui <- page_fillable(
  # Define theme using Bootswatch "pulse" and Google font "Inter"
  theme = bs_theme(
    bootswatch = "pulse",
    version = 5,
    primary = "#012c6c",          # Primary brand color
    base_font = font_google("Inter")
  ),

  # Create the main chat card
  card(
    # Card header section
    card_header("Chatbot",
                style = "background-color: #012c6c; color: white;",

                # Popover for chat settings (gear icon opens settings)
                popover(
                  trigger = bs_icon("gear", class = "ms-auto"),

                  # Input fields inside the settings popover
                  passwordInput("api_key", "Enter your OPENAI Key"),  # API key field
                  selectInput("model", "Select OpenAI Model",
                              choices = c("gpt-3.5-turbo", "gpt-4-turbo-preview")
                  ),
                  selectInput("task", "Task",
                              choices = c("general", "code")
                  ),
                  title = "chat settings"
                ),
                class = "d-flex align-items-center-gap-1"
    ),

    # Dynamic UI output for showing instructions
    uiOutput("instructions"),

    # Chat UI component
    chat_ui(
      id = "chat",
      messages = "**Hello!** How can I help you today?"
    ),

    # Make layout responsive on mobile
    fillable_mobile = TRUE
  )
)



# ----------------------------
# SERVER SECTION
# ----------------------------
server <- function(input, output, session) {

  # Observe if API key is entered; show instructions if missing
  observe({
    if (input$api_key == "") {
      output$instructions <- renderUI({
        markdown("
        **Please enter your OpenAI API key to start chatting.**
        You can get your API key from the [OpenAI website](https://platform.openai.com).
        Click the gear icon ⚙️ to open settings.
        ")
      })
    } else {
      # Clear instructions once key is entered
      output$instructions <- renderUI(NULL)
    }
  })


  # Create and configure the chat connection once API key is provided
  observeEvent(input$api_key, {
    req(input$api_key)   # Ensure key exists before running

    # Initialize OpenAI chat connection via ellmer
    chat <- ellmer::chat_openai(
      system_prompt = "Respond to the user as succinctly as possible.",
      api_key = input$api_key   # Inject user-provided API key directly
    )

    # Listen for user chat input and send to OpenAI
    observeEvent(input$chat_user_input, {
      tryCatch({
        # Stream the AI's response asynchronously
        stream <- chat$stream_async(input$chat_user_input)

        # Display the AI's response in the chat UI
        chat_append("chat", stream)
      }, error = function(e) {
        # Show an error notification if connection fails
        showNotification(
          "⚠️ There was a problem connecting to OpenAI. Please check your API key or quota.",
          type = "error",
          duration = NULL
        )
      })
    })
  })
}


# ----------------------------
# RUN THE APP
# ----------------------------
shinyApp(ui, server)
