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

## Assumptions
For the sake of scope, some assumptions were made. I will list them below:
* The user will always spell city names correctly. I thought about using a lookup table to tie a state with all its associated cities, but that would have taken too long.
* The user will always type in a 5 digit zip code. I am aware that there are things like zip code extensions but opted not to account for that.
* Any new CSVs the user desires to upload will never have any properties that have been in a previous CSV. For example, if I had finalized 'Avenue Apartments' in one CSV, 'Avenue Apartments' will never show up again in a future CSV file with new information - I am assuming that a user who finalizes information is 100% happy and confident that there are no mistakes, lest they have to delete the entire database again and start over.
* CSV header naming conventions will always be consistent with: "Building Name",	"Street Address",	"Unit",	"City",	"State",	"Zip Code". This is to remove further validation implications, as dealing with misspelled headers would add another layer of complexity that is out of scope for this project.
* The user would want to have an export option available to generate a new CSV with the corrected information.
* The user doesn't want to deal with deciding which duplicate property to delete.
* All information will be uppercase and stripped of non-alphanumeric characters for consistency.

## Tradeoffs
I think the tradeoffs go hand in hand with the assumptions, but for brevity I will also talk about these briefly.
* Cities: I wanted to have a dropdown menu for cities, similar to how the states have, but it seemed to be more trouble than it was worth to track down all of the cities in each state and enter them in a separate YML file just for this feature. If I had the time, this is something that would eliminate any chance of misspelling a city.
* On the flip side, creating dropdown menus have the potential for accidentally setting a property with the wrong state. I've done it myself, where in a rush to add a property for testing I left the state as 'Alaska' as it was the first option in the dropdown. One way I could have mitigated this was to add a 'blank' state, where if my property model detected that the state was in 'blank', it would throw an error at me.
* I wanted to improve the look of this website as somebody who loves beautiful websites, but alas I ran out of time :(
* Although I think the way I handled doing CRUD operations on Units was the 'Ruby way of doing it', it may not be the most easily extensible. For instance if the Units needed to have parameters like bedrooms, bathrooms, square footage, etc, I may have to generate a new migration file to include these parameters, then rework the UI to include each Units' parameters.

## Identifying Duplicate Properties
This was a great problem to solve! Thinking about how to handle duplicate properties made me really scratch my head. Initially, I was thinking about just having the duplicate properties show up in the preview and have a banner warning that let the user know that there was a duplicate property. This would have been achieved by pulling from the imported properties table and finding that "hey, these two strings match up, so therefore they are duplicates". However, (in the assumptions ;) ) I figured that the customer would want duplicates to be handled automatically. In my CSV Parser logic, I made it so if the property's unique identifier (its name) was detected twice, that information would be thrown out. 

If the user wanted to add a new property and it happened to be a duplicate property (say 'Avenue Apartments' already exists and I type it in as a new property), the validates :name, :uniqueness validation in my model would throw an error indicating that there is a property by the same identifier. 

One edge case I ran into that I eventually turned into an assumption was when I uploaded a new CSV after finalizing a previous one - if I tried to confirm my submission, while duplicate properties were still rejected, any new information was unable to be entered. For instance, the 'Avenue Apartments' has a total of 7 Units in the CSV. If I had created a new CSV with all of the same information as the previous 'Avenue Apartments', and simply added a couple of new rows with new units, the validator would simply not allow this to be submitted. Hence, I made the assumption that a user who finalizes a Property is 100% confident that they entered everything correctly after reviewing and updating information. After all, this website allows you to make changes to the property data before you finalize it.

## Improvements to Make
