const formHTML = `
<!DOCTYPE HTML>
<html lang="en-US">
<head>

    <title>Sign Me Up!</title>

    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    
    
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="referrer" content="no-referrer-when-downgrade">
            <script type="text/javascript">
        document.addEventListener("DOMContentLoaded", function(){
            const FORM_TIME_START = Math.floor((new Date).getTime()/1000);
            let formElement = document.getElementById("tfa_0");
            if (null === formElement) {
                formElement = document.getElementById("0");
            }
            let appendJsTimerElement = function(){
                let formTimeDiff = Math.floor((new Date).getTime()/1000) - FORM_TIME_START;
                let cumulatedTimeElement = document.getElementById("tfa_dbCumulatedTime");
                if (null !== cumulatedTimeElement) {
                    let cumulatedTime = parseInt(cumulatedTimeElement.value);
                    if (null !== cumulatedTime && cumulatedTime > 0) {
                        formTimeDiff += cumulatedTime;
                    }
                }
                let jsTimeInput = document.createElement("input");
                jsTimeInput.setAttribute("type", "hidden");
                jsTimeInput.setAttribute("value", formTimeDiff.toString());
                jsTimeInput.setAttribute("name", "tfa_dbElapsedJsTime");
                jsTimeInput.setAttribute("id", "tfa_dbElapsedJsTime");
                jsTimeInput.setAttribute("autocomplete", "off");
                if (null !== formElement) {
                    formElement.appendChild(jsTimeInput);
                }
            };
            if (null !== formElement) {
                if(formElement.addEventListener){
                    formElement.addEventListener('submit', appendJsTimerElement, false);
                } else if(formElement.attachEvent){
                    formElement.attachEvent('onsubmit', appendJsTimerElement);
                }
            }
        });
    </script>

    <link href="https://miraclefoundation.tfaforms.net/dist/form-builder/5.0.0/wforms-layout.css?v=ad27a8c504baf524f2fc692fef424b534e5a9fc3" rel="stylesheet" type="text/css" />

    <!--<link href="https://miraclefoundation.tfaforms.net/uploads/themes/theme-29.css" rel="stylesheet" type="text/css" />-->
    <link href="https://miraclefoundation.tfaforms.net/dist/form-builder/5.0.0/wforms-jsonly.css?v=ad27a8c504baf524f2fc692fef424b534e5a9fc3" rel="alternate stylesheet" title="This stylesheet activated by javascript" type="text/css" />
    <script type="text/javascript" src="https://miraclefoundation.tfaforms.net/wForms/3.11/js/wforms.js?v=ad27a8c504baf524f2fc692fef424b534e5a9fc3"></script>
    <script type="text/javascript">
        wFORMS.behaviors.prefill.skip = false;
    </script>
        <script type="text/javascript" src="https://miraclefoundation.tfaforms.net/wForms/3.11/js/localization-en_US.js?v=ad27a8c504baf524f2fc692fef424b534e5a9fc3"></script>

            
    
</head>
<body class="default wFormWebPage" >


    <div id="tfaContent">
        <div class="wFormContainer" >
    <div class="wFormHeader"></div>
    <style type="text/css">
        .wFormContainer{
            margin: 0px !important
        }
        .wForm{
            padding: 10px 0
        }
        .wFormTitle{
            font-size: 1.3rem !important;
            font-family: Georgia !important;
            font-weight: 800 !important;
            line-height: 1.2 !important;
            padding: 0 !important;
            margin: 0 !important;
            color: #002244 !important;
            max-width: 450px;
        }
        .htmlSection, .oneField{
            padding: 0 !important;
            margin: 0 !important;
            border: none !important;
        }
        .htmlContent{
            font-size: 15px !important;
            font-family: Montserrat, Arial !important;
            font-weight: 400 !important;
            line-height: 1.5 !important;
            color: #002244 !important;
        }
        .actions{
            margin-top: 3px !important;
        }
        .primaryAction{
            color: #FFFFFF !important;
            background-color: #F37123 !important;
            box-shadow: 0px 3px 1px -2px rgb(0 0 0 / 20%), 0px 2px 2px 0px rgb(0 0 0 / 14%), 0px 1px 5px 0px rgb(0 0 0 / 12%) !important;
            padding: 6px 16px !important;
            font-size: 0.875rem !important;
            min-width: 64px !important;
            box-sizing: border-box !important;
            font-family: Montserrat, Arial !important;
            font-weight: 500 !important;
            line-height: 1.75 !important;
            border-radius: 4px !important;
            text-transform: uppercase !important;
            border: none !important;
        }
        #tfa_2,
        *[id^="tfa_2["] {
            width: 340px !important;
            height: 35px !important;
            border: 1px solid rgba(0, 0, 0, 0.12) !important;
            border-radius: 5px !important;
            padding-left: 5px !important;
            outline: none !important;
            margin-top: 10px;
        }
        #tfa_2-D,
        *[id^="tfa_2["][class~="field-container-D"] {
            width: auto !important;
        }
    
        #tfa_2-L,
        label[id^="tfa_2["] {
            width: 280px !important;
            min-width: 0px;
        }
    
        #tfa_13,
        *[id^="tfa_13["] {
            width: 340px !important;
            height: 35px !important;
            border: 1px solid rgba(0, 0, 0, 0.12) !important;
            border-radius: 5px !important;
            padding-left: 5px !important;
            outline: none !important;
            margin-top: 10px;
        }
        #tfa_13-D,
        *[id^="tfa_13["][class~="field-container-D"] {
            width: auto !important;
        }
    
        #tfa_13-L,
        label[id^="tfa_13["] {
            width: 280px !important;
            min-width: 0px;
        }
    
        #tfa_11,
        *[id^="tfa_11["] {
            width: 340px !important;
            height: 35px !important;
            border: 1px solid rgba(0, 0, 0, 0.12) !important;
            border-radius: 5px !important;
            padding-left: 5px !important;
            outline: none !important;
            margin-top: 10px;
        }
        #tfa_11-D,
        *[id^="tfa_11["][class~="field-container-D"] {
            width: auto !important;
        }
    
        #tfa_11-L,
        label[id^="tfa_11["] {
            width: 280px !important;
            min-width: 0px;
        }
    </style><div class="">
    <div class="wForm" id="74-WRPR" dir="ltr">
<div class="codesection" id="code-74"></div>
<h3 class="wFormTitle" data-testid="form-title" id="74-T">Coming in January to agencies across Texas! Just enter your information and we will keep everyone informed on FosterShare!</h3>
<form method="post" action="https://miraclefoundation.tfaforms.net/responses/processor" class="hintsBelow labelsAbove" id="74" role="form">
<div class="htmlSection" id="tfa_14"><div class="htmlContent" id="tfa_14-HTML">A&nbsp;<span style="word-spacing: normal;">FosterShare</span><sup style="word-spacing: normal;">TM&nbsp;</sup>Rep will reach back soon.</div></div>
<div id="tfa_9" class="section group">
<div class="oneField field-container-D    " id="tfa_2-D">
    <!--<label id="tfa_2-L" class="label preField reqMark" for="tfa_2">Name</label><br>-->    
    <div class="inputWrapper">
        <input aria-required="true" type="text" id="tfa_2" name="tfa_2" value="" title="Name" placeholder="Name" class="required">
    </div>
</div>
<div class="oneField field-container-D    " id="tfa_13-D">
    <!--<label id="tfa_13-L" class="label preField reqMark" for="tfa_13">Email</label><br>-->    
    <div class="inputWrapper">
        <input aria-required="true" type="text" id="tfa_13" name="tfa_13" value="" title="Email" placeholder="Email" class="validate-email required">
    </div>
</div>
<div class="oneField field-container-D    " id="tfa_11-D">
    <!--<label id="tfa_11-L" class="label preField reqMark" for="tfa_11">Agency</label><br>-->    
    <div class="inputWrapper">
        <input aria-required="true" type="text" id="tfa_11" name="tfa_11" value="" title="Agency" placeholder="Agency" class="required">
    </div>
    </div>
</div>
<div class="actions" id="74-A"><input type="submit" data-label="Submit" class="primaryAction" id="submit_button" value="Submit"></div>
<div style="clear:both"></div>
<input type="hidden" value="74" name="tfa_dbFormId" id="tfa_dbFormId"><input type="hidden" value="" name="tfa_dbResponseId" id="tfa_dbResponseId"><input type="hidden" value="beac6a3ad0a3968f8d1367acbcc8c2f0" name="tfa_dbControl" id="tfa_dbControl"><input type="hidden" value="" name="tfa_dbWorkflowSessionUuid" id="tfa_dbWorkflowSessionUuid"><input type="hidden" value="11" name="tfa_dbVersionId" id="tfa_dbVersionId"><input type="hidden" value="" name="tfa_switchedoff" id="tfa_switchedoff">
</form>
</div></div><div class="wFormFooter"><p class="supportInfo"><br></p></div>
  <p class="supportInfo" >
      </p>
 </div>
    </div>

        <script src='https://miraclefoundation.tfaforms.net/js/iframe_message_helper_internal.js?v=2'></script>

</body>
</html>
`
 export default formHTML;