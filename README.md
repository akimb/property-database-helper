# README

Welcome to my property database project! 

## Here's how to run this application locally:
1. Download and clone this repository to your machine.
2. Store it in a folder path of your choice.
3. If you're on Windows and have not yet downloaded [WSL for Windows](https://learn.microsoft.com/en-us/windows/wsl/install), please do so. Otherwise, in your terminal, run `wsl`.
4. If you're on Linux, use your preferred flavor.
5. `cd` into your file path. It should end in `/property-database-helper` or `\property-database-helper`.
6. Run the command `rails s` or `rails server` to begin the server.
7. On your web browser of choice, type in [http://localhost:3000](http://localhost:3000) and wait for the rails server to finish rendering the page.
8. Once you see the website, upload the Properties CSV and click 'Upload CSV'.
9. Once uploaded, you'll see a view of all of the properties associated with the CSV as well as the other information, like city, zipcode, and units for instance.
10. Upon imports, you may see that some properties have warnings next to them. The property database will run through validators and give warnings based on if something is typed incorrectly.
11. You may edit a property below its description. If you wanted to change the address, city, state, zipcode, and add/edit/delete units, that is all processed in the edit view. Should you wish to delete a unit, simply select the checkbox next to it to queue it for deletion. Upon clicking 'Save Changes', the units will be deleted.  
12. You may also add a property with the options to add units, as well as type in name and all other information. Accurate information is required when adding in a new property, the validator will not pass the submit form.
13. Lastly, you may delete properties should you need to.
14. Once you are satisfied and fixed any errors, you are able to 'Submit Final' and get a preview of the final properties before you 'Confirm Submission'. From there you will have a finalized version of the property database in which you can also export as a new CSV.

## 
