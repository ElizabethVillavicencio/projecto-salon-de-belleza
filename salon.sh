#!/bin/bash

echo "~~~~~ MY SALON ~~~~~"
echo "Welcome to My Salon, how can I help you?"


SERVICES_LIST=$(psql --username=freecodecamp --dbname=salon -t -A -c "SELECT service_id || ') ' || name FROM services;")
echo "We offer the following services:"
echo "$SERVICES_LIST"

echo ""
echo "Please enter the service number (1-5):"
read SERVICE_ID_SELECTED


display_services() {
  echo "$SERVICES_LIST"
}


SERVICE_EXISTS=$(psql --username=freecodecamp --dbname=salon -t -A -c "SELECT COUNT(*) FROM services WHERE service_id = $SERVICE_ID_SELECTED;")
while [[ $SERVICE_EXISTS -eq 0 ]]; do
  echo "I could not find that service. What would you like today?"
  display_services
  echo ""
  echo "Please enter the service number (1-5):"
  read SERVICE_ID_SELECTED
  SERVICE_EXISTS=$(psql --username=freecodecamp --dbname=salon -t -A -c "SELECT COUNT(*) FROM services WHERE service_id = $SERVICE_ID_SELECTED;")
done


echo "What's your phone number?"
read CUSTOMER_PHONE


CUSTOMER_EXISTS=$(psql --username=freecodecamp --dbname=salon -t -A -c "SELECT COUNT(*) FROM customers WHERE phone = '$CUSTOMER_PHONE';")

if [[ $CUSTOMER_EXISTS -eq 0 ]]; then
  echo "I don't have a record for that phone number, what's your name?"
  read CUSTOMER_NAME
  psql --username=freecodecamp --dbname=salon -c "INSERT INTO customers (name, phone) VALUES ('$CUSTOMER_NAME', '$CUSTOMER_PHONE');"
else
  CUSTOMER_NAME=$(psql --username=freecodecamp --dbname=salon -t -A -c "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE';")
fi


echo "What time would you like your service, $CUSTOMER_NAME?"
read SERVICE_TIME


CUSTOMER_ID=$(psql --username=freecodecamp --dbname=salon -t -A -c "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE';")


psql --username=freecodecamp --dbname=salon -c "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');"


SERVICE_NAME=$(psql --username=freecodecamp --dbname=salon -t -A -c "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED;")
echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
