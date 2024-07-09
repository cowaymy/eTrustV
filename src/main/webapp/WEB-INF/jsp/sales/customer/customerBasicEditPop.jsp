<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
     var selCodeCustId;
     var selCodeCorpId;
     var selCodeNation;
     var selCodeRaceId;
$(document).ready(function(){

    //j_date
    var pickerOpts={
            changeMonth:true,
            changeYear:true,
            dateFormat: "dd/mm/yy"
    };

    $(".j_date").datepicker(pickerOpts);

    var monthOptions = {
        pattern: 'mm/yyyy',
        selectedYear: 2017,
        startYear: 2007,
        finalYear: 2027
    };

    $(".j_date2").monthpicker(monthOptions);

    //selected Codes
    selCodeCustId = $("#selCodeCustId").val(); // TypeId
    selCodeCorpId = $("#selCodeCorpId").val();
    selCodeNation = $("#selCodeNation").val();
    selCodeRaceId = $("#selCodeRaceId").val(); //race id


    doGetCombo('/common/selectCodeList.do', '95', selCodeCorpId ,'basicCmbCorpTypeId', 'S', '');     // Company Type Combo Box
    doGetCombo('/common/selectCodeList.do', '8', selCodeCustId ,'basicCmbCustTypeId', 'S', '');       // Customer Type Combo Box
    doGetCombo('/sales/customer/getNationList', '338' , selCodeNation ,'basicCmdNationTypeId' , 'S');        // Nationality Combo Box
    doGetCombo('/common/selectCodeList.do', '2', selCodeRaceId ,'basicCmdRaceTypeId', 'S', ''); //cmdRaceTypeId
    //TypeId 에 따른 수정항목 Control
    // individual
    if(selCodeCustId == '964'){
        $("#basicCmbCustTypeId").attr("disabled" , "disabled");
        $("#basicCmbCorpTypeId").attr({"class" : "disabled w100p" , "disabled" : "disabled"});
        $("#basicNric").attr({"class":"readonly w100p","readonly" : "readonly"});
        $("input[name='basicGender']").attr("disabled" , false);
        $("#basicCmdRaceTypeId").attr("disabled" , false);
        //$("#basicCmdNationTypeId").attr("disabled" , "disabled");
        //$("#basicDob").attr("disabled" , "disabled");
        $("#basicSstRegNo").val('');
        $("#basicSstRegNo").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
    }
    // company
    if(selCodeCustId == '965'){
        $("#basicCmbCustTypeId").attr("disabled" , "disabled");
        $("#basicCmbCorpTypeId").attr({"class" : "w100p" , "disabled" : false});
        $("#basicNric").removeClass("disabled");
        $("input[name='basicGender']").attr({"disabled" : "disabled" , "checked" : false});
        $("#basicCmdRaceTypeId").attr({"disabled" : "disabled" , "class":"disabled w100p"});
        $("#basicCmdNationTypeId").attr("disabled" , "disabled");
        $("#basicDob").attr("disabled" , "disabled");
        $("#basicSstRegNo").removeAttr("disabled");
        $("#basicSstRegNo").removeClass("disabled");
        if($("#basicCmbCorpTypeId :selected").val() == '1151' ){
        	$("#basicCustTin").val('');
            $("#basicCustTin").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
        }
    }
    //edit
     // 수정 항목 변경
    $("#_editCustomerInfo").change(function(){

            var stateVal = $(this).val();
            $("#_selectParam").val(stateVal);
    });

    $("#_confirm").click(function (currPage) {
    	fn_comboAuthCtrl();
    });


 // update Button Click
    $("#_updBtn").click(function(){

        if(selCodeCustId == '964'){
            // 1. validation
            //Customer Name
            if('' == $("#basicName").val() || null == $("#basicName").val()){
                Common.alert("<spring:message code='sal.alert.msg.pleaseEnterCustName' />");
                return;
            }
            //Race
            if('' == $("#basicCmdRaceTypeId").val() || null == $("#basicCmdRaceTypeId").val()){
                Common.alert("<spring:message code='sal.alert.msg.pleaseEnterRace' />");
                return;
            }
            //Email
            if('' != $("#basicEmail").val() && null != $("#basicEmail").val()){

                if(FormUtil.checkEmail($("#basicEmail").val()) == true){
                    Common.alert("<spring:message code='sal.msg.invalidEmail' />");
                    return;
                 }
            }
          //basicNric
            if('' == $("#basicNric").val() ||  null == $("#basicNric").val()){

            	Common.alert("<spring:message code='sal.alert.msg.plzKeyInCustNricComNo' />");
                return;
                }
                else {


             //    var CUST_NRIC =	$('#basicNric').val().trim();
               	var existNric = fn_validNricExist();
               	var ic = $('#basicNric').val().trim();
               	var lastDigit = parseInt(ic.charAt(ic.length - 1));
               	var genderCode = $('#basicGender').val().trim();
                var msg = "";
                var isValid = true;
                var pattern = new RegExp(/[~`!#$%\^&*+=\-\[\]\\';,/{}.|\\":<>\?]/);

                if('${result.nation}' == '1' && ic.length == 12)
	                $("#basicDob").val(nricToDob(ic));

                if('${result.nation}' == '1' && ic.length == 12)
                    $("#basicGender").val(nricToGender(ic));


                console.log('existNric:' + existNric);
                console.log('lastDigit:' + lastDigit);
                console.log('GenderCode:' + genderCode);
                console.log('isValid:' + isValid);
                console.log('ic_NO update to :' + ic);
                console.log("" + $("#basicDob").val());

               if (pattern.test(ic)) {
            	   isValid = false;
                	Common.alert("Please ensure NRIC does not contains special characters");
                	return ;
                }

               if (existNric != 0  ) {
                 isValid = false;
                 Common.alert("This NRIC already exist");
                    return ;
               }

               if($("#basicCmdNationTypeId").val() == '1'){
            	   //var regex = new RegExp("/((([02468][048]|[13579][26])(02)(29))|(([0-9]{2})((0[1-9]|1[0-2])(0[1-9]|1[0-9]|2[0-8])|(0[1|3-9]|1[0-2])(29|30)|(0[13578]|1[02])(31))))([0-9]{2})([0-9]{4})$/");
                   var regex= new RegExp("(([0-9]{2}(?!0229))|([02468][048]|[13579][26])(?=0229))(0[1-9]|1[0-2])(0[1-9]|[12][0-9]|(?<!02)30|(?<!02|4|6|9|11)31)[0-9]{2}[0-9]{4}$");
            	   var str = $("#basicNric").val();
                   if (regex.test(str)) {
                       //return true;
                   }
                   else{
                       Common.alert('Invalid format for NRIC/Company No.');
                       return false;
                   }
               }

               if($("#basicNric").val().length != 12){
                   Common.alert('Only allow 12 digits for NRIC/Company No.');
                   return false;
               }

                /* if ( genderCode == "F") {
                   if (lastDigit % 2 != 0) {
                    isValid = false;
                    console.log('msg:: Gender not match with NRIC');
                    Common.alert("<spring:message code='sal.msg.invalidNric' />");
                        return;
               }
                    } else {
                      if (lastDigit % 2 == 0) {
                        isValid = false;
                      console.log('msg:: Gender not match with NRIC');
                     Common.alert("<spring:message code='sal.msg.invalidNric' />");
                     return;

                      }
                    } */

                 //sys0052M

            }
        }

        /*********** company ***********/
        if(selCodeCustId == '965'){
            // 1. validation
            //Company Type
            if('' == $("#basicCmbCorpTypeId").val() || null == $("#basicCmbCorpTypeId").val()){
                Common.alert("<spring:message code='sys.common.alert.validation' arguments='Company Type'/>");
                return;
            }
            //Customer Name
            if('' == $("#basicName").val() || null == $("#basicName").val()){
                Common.alert("<spring:message code='sys.common.alert.validation' arguments='Customer Name'/>");
                return;
            }
            //Email
            if('' != $("#basicEmail").val() && null != $("#basicEmail").val()){

                if(FormUtil.checkEmail($("#basicEmail").val()) == true){
                    Common.alert("<spring:message code='sal.msg.invalidEmail' />");
                    return;
                 }
            }

            if($("#basicCmbCorpTypeId").val() != '1151'){
            	var regex1 = new RegExp("^[0-9]+$");
                var str1 = $("#basicNric").val();
                if (regex1.test(str1)) {
                     if($("#basicNric").val().length != 12){
                         Common.alert('Only allow 12 characters for NRIC/Company No.');
                         return false;
                     }
                    //return true;
                }
                else{
                    Common.alert('Only allow 12 digits for NRIC/Company No.');
                    return false;
                }
            } else {
                if($("#basicNric").val().length > 20){
                    Common.alert('Only allow 20 digits for NRIC/Company No.');
                    return false;
                }
            }

            // Company TIN
            if($("#basicCmbCorpTypeId").val() != "1333" && $("#basicCmbCorpTypeId").val() != "1151"){
            	 if($("#basicCustTin").val() == "" || $("#basicCustTin").val() == null){
                     Common.alert("Please enter Company TIN to proceed.");
                     return;
                  }
            }

            // SST No
            if($("#basicSstRegNo").val() != ""){

                if($("#basicSstRegNo").val().length == 35){

                }else if($("#basicSstRegNo").val().length == 17){

                }else{
                    Common.alert("Please make sure SST No format is valid");
                    return false;
                }

                var regex3 = new RegExp("^[A-Za-z0-9\-\;]+$");
                var str = $("#basicSstRegNo").val();
                if (regex3.test(str)) {
                    //return true;
                }
                else{
                    Common.alert("Special characters other than - and /; is not allowed. ");
                    return false;
                }
            }
        }

        if($("#_tin_").val() != ""){
            if($("#basicCustTin").val().length < 11  || $("#basicCustTin").val().length > 14){
                Common.alert("Please make sure TIN No is within 11 to 14 characters. ");
                return false;
            }
        }


        // [Celeste] 29-05-2024 : move eInvoice flag to bill group
       /*  if($('input:checkbox[id="isEInvoice"]').is(":checked") == true){
        	if($("#basicCustTin").val() != ''){
        		$("#isEInvoiceNew").val("1");
            }else{
                $("#isEInvoiceNew").val("0");
                Common.alert('Please fill in TIN to receive e-Invoice.');
                return;
            }}
        else{
        	$("#isEInvoiceNew").val("0");
        	} */

        //update
        fn_getCustomerBasicAjax();

    });


    //Btn Auth
    if(basicAuth == true){
    	$("#_basicUpdBtn").css("display" , "");
    }else{
    	$("#_basicUpdBtn").css("display" , "none");
    }
}); // document ready end

    //update
    function fn_getCustomerBasicAjax(){
    	console.log($("#updForm").serializeJSON());
        Common.ajax("GET", "/sales/customer/updateCustomerBasicInfoAf.do",$("#updForm").serializeJSON(), function(result) {
            Common.alert(result.message, fn_reloadPage);
        });
    }

    //reload Page func
    function fn_reloadPage(){
        //Parent Window Method Call
        fn_selectPstRequestDOListAjax();
        Common.popupDiv('/sales/customer/updateCustomerBasicInfoPop.do', $('#popForm').serializeJSON(), null , true , '_editDiv1');
        $("#_close").click();
    }

    //close Func
    function fn_closeFunc(){
        $("#_selectParam").val(1);
    }

    /////////////////////////////////////////////  NRIC validation ///////////////////////////////////////////////////////
    function fn_validNric() {
        var isValid = true, msg = "";

        if (FormUtil.isEmpty($('#basicNric').val().trim())) {
          isValid = false;
          msg += '<spring:message code="sal.alert.msg.plzKeyInCustNricComNo" />';
        } else {

          var existNric = fn_validNricExist();

          console.log('existNric:' + existNric);

          if (existNric > 0) {
            isValid = false;
            msg += '<spring:message code="sal.alert.msg.existingCustId" />'
                + existNric;

          } else {
            if ($('#modCustType').val().trim() == '964') {
              var ic = $('#modCustNric').val().trim();
              var lastDigit = parseInt(ic.charAt(ic.length - 1));

              if (lastDigit != null) {
                if ($('#modCustGender').val() == "F") {
                  if (lastDigit % 2 != 0) {
                    isValid = false;
                    msg += '<spring:message code="sal.alert.msg.invalidNric" />';
                  }
                } else {
                  if (lastDigit % 2 == 0) {
                    isValid = false;
                    msg += '<spring:message code="sal.alert.msg.invalidNric" />';
                  }
                }
              }
            }
          }
        }

        if (!isValid)
          Common
              .alert('<spring:message code="sal.alert.msg.saveValidation" />'
                  + DEFAULT_DELIMITER + "<b>" + msg + "</b>");

        console.log('msg:' + msg);
        console.log('isValid:' + isValid);

        return isValid;
      }

    function fn_validNricExist() {

    	var CUST_NRIC = $('#basicNric').val().trim();
        var exCustNric = 0;

        Common.ajax("GET", "/sales/customer/checkNricExist.do", $('#updForm')
.serializeJSON(), function(result) {


          if (result != null) {

            exCustNric = result.nric;
            console.log('result.nric:' + exCustNric);

          }

        }, null, {
          async : false
        });

        return exCustNric;
      }

    function nricToGender(ic){
        var lastDigit = parseInt(ic.charAt(ic.length - 1));
         let gender = "";
        if ( ic.length == 12) {
                       if (lastDigit % 2 != 0) {
                            isValid = false;
                            console.log('Male');
                            $('input:radio[name="basicGender"][value="M"]').prop('checked', true);
                            gender = "M";
                            return gender;
                        }
                      if (lastDigit % 2 == 0) {
                          isValid = false;
                          console.log('Female');
                          $('input:radio[name="basicGender"][value="F"]').prop('checked', true);
                          gender = "F";
                          return gender;
                    }
         }
    }

    function nricToDob(nric){
    	let currentYear = new Date().getFullYear();
        let dob = "";

        let currentYearSubStr = currentYear.toString().substr(2,2);
        let year  = nric.substr(0, 2);
        let month = nric.substr(2, 2);
        let day   = nric.substr(4, 2);

        if(year >= currentYearSubStr && year <= 99){
            year = "19" + year;
        }else{
            year = "20" + year;
        }


        dob = day + "-" + month + "-" + year;

        return dob;
    }

/////////////////////////////////////////////  NRIC validation ///////////////////////////////////////////////////////

</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<!-- getParams  -->
<input type="hidden" value="${result.typeId }" id="selCodeCustId"> <!-- TypeId : 964(Individual) / 965(Company)  -->
<input type="hidden" value="${result.corpTypeId}" id="selCodeCorpId">
<input type="hidden" value="${result.nation }" id="selCodeNation">
<input type="hidden" value="${result.raceId }" id="selCodeRaceId">

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.page.title.custBasicInfoMaintenance" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="_close" onclick="javascript: fn_closeFunc()"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->


<section class="pop_body"><!-- pop_body start -->
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.editType" /></th>
    <td>
    <select id="_editCustomerInfo">
        <option value="1" <c:if test="${selectParam eq 1}">selected</c:if>><spring:message code="sal.combo.text.editBasicInfo" /></option>
        <option value="2" <c:if test="${selectParam eq 2}">selected</c:if>><spring:message code="sal.combo.text.editCustAddr" /></option>
        <option value="3" <c:if test="${selectParam eq 3}">selected</c:if>><spring:message code="sal.combo.text.editContactInfo" /></option>
        <option value="4" <c:if test="${selectParam eq 4}">selected</c:if>><spring:message code="sal.combo.text.editBankAcc" /></option>
        <option value="5" <c:if test="${selectParam eq 5}">selected</c:if>><spring:message code="sal.combo.text.editCreditCard" /></option>
        <option value="6" <c:if test="${selectParam eq 6}">selected</c:if>><spring:message code="sal.combo.text.editBasicInfoLimit" /></option>
    </select>
    <p class="btn_sky"><a href="#" id="_confirm"><spring:message code="sal.btn.confirm" /></a></p>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.page.title.custInformation" /></h2>
</aside><!-- title_line end -->

<section class="tap_wrap mt10"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on"><spring:message code="sal.tap.title.basicInfo" /></a></li>
    <li><a href="#"><spring:message code="sal.tap.title.mainAddr" /></a></li>
    <li><a href="#"><spring:message code="sal.tap.title.mainContact" /></a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:120px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.customerId" /></th>
    <td><span>${result.custId}</span></td>
    <th scope="row"><spring:message code="sal.text.custType" /></th>
    <td>
        <span>
                ${result.codeName1}
                <!-- not Individual -->
                <c:if test="${ result.typeId ne 964}">
                    (${result.codeName})
                </c:if>
            </span>
    </td>
    <th scope="row"><spring:message code="sal.text.createAt" /></th>
    <td>${result.crtDt}</td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.custName" /></th>
    <td colspan="3">${result.name}</td>
    <th scope="row"><spring:message code="sal.text.createBy" /></th>
    <td>
        <c:if test="${result.crtUserId ne 0}">
                ${result.userName}
            </c:if>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.nricCompanyNum" /></th>
    <td><span>${result.nric}</span></td>
    <th scope="row"><spring:message code="sal.text.gstRegistrationNo" /></th>
    <td>${result.gstRgistNo}</td>
    <th scope="row"><spring:message code="sal.text.updateBy" /></th>
    <td>${result.userName1}</td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.email" /></th>
    <td><span>${result.email}</span></td>
    <th scope="row"><spring:message code="sal.text.nationality" /></th>
    <td>${result.cntyName}</td>
    <th scope="row"><spring:message code="sal.text.updateAt" /></th>
    <td>${result.updDt}</td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.gender" /></th>
    <td><span>${result.gender}</span></td>
    <th scope="row"><spring:message code="sal.text.dob" /></th>
    <td>
        <c:if test="${result.dob ne '01-01-1900'}">
                ${result.dob}
        </c:if>
    </td>
    <th scope="row"><spring:message code="sal.text.race" /></th>
    <td>${result.codeName2 }</td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.passportExpire" /></th>
    <td><span>${result.pasSportExpr}</span></td>
    <th scope="row"><spring:message code="sal.text.visaExpire" /></th>
    <td>${result.visaExpr}</td>
    <th scope="row"><spring:message code="sal.text.vaNumber" /></th>
    <td>${result.custVaNo}</td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.tierStatus" /></th>
    <td>${result.tierStatus}</td>
    <th scope="row"><spring:message code="sal.title.text.curPoint" /></th>
    <td>${result.curPoint}</td>
    <th scope="row"><spring:message code="sal.title.text.ExpingPoint" /></th>
    <td>${result.expingPoint}</td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.onholdPoint" /></th>
    <td>${result.onholdPoint}</td>
    <th scope="row"><spring:message code="sal.title.text.expiredPoint" /></th>
    <td>${result.expiredPoint}</td>
    <th scope="row"><spring:message code="sal.title.text.tin" /></th>
    <td>${result.custTin}</td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.sstRegistrationNo" /></th>
    <td>${result.sstRgistNo}</td>
    <th scope="row"></th>
    <td></td>
    <!-- [Celeste] 29-05-2024 : move eInvoice flag to bill group -->
    <%-- <th scope="row"><spring:message code="sal.title.text.eInvoicFlag" /></th>
    <td>
        <c:choose>
        <c:when test="${result.eInvFlg eq '1'}">
            <input id="isEInvoiceDisplay" name="isEInvoiceDisplay" type="checkbox" onClick="return false" checked/>
        </c:when>
        <c:otherwise>
            <input id="isEInvoiceDisplay" name="isEInvoiceDisplay" type="checkbox" onClick="return false"/>
        </c:otherwise>
        </c:choose>
    </td> --%>
    <th scope="row"></th>
    <td></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.remark" /></th>
    <td colspan="5"><span>${result.rem}</span></td>
</tr>
</tbody>
</table><!-- table end -->
</article><!-- tap_area end -->
<!-- ######### main address info ######### -->
<article class="tap_area"><!-- tap_area start -->
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.fullAddr" /></th>
    <td><span>${addresinfo.fullAddress}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.remark" /></th>
    <td>${addresinfo.rem}</td>
</tr>
</tbody>
</table><!-- table end -->
</article><!-- tap_area end -->

<!-- ######### main Contact info ######### -->
<article class="tap_area"><!-- tap_area start -->
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:120px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:120px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.name" /></th>
    <td><span>${contactinfo.name1}</span></td>
    <th scope="row"><spring:message code="sal.text.initial" /></th>
    <td><span>${contactinfo.code}</span></td>
    <th scope="row"><spring:message code="sal.text.gender" /></th>
    <td>
            <c:choose >
                <c:when test="${contactinfo.gender eq 'M'}">
                     Male
                </c:when>
                <c:when test="${contactinfo.gender eq 'F'}">
                     Female
                </c:when>
                <c:otherwise>
                    <!-- korean : 5  -->
                </c:otherwise>
            </c:choose>
     </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.nric" /></th>
    <td><span>${contactinfo.nric}</span></td>
    <th scope="row"><spring:message code="sal.text.dob" /></th>
    <td>
        <span>
            <c:if test="${contactinfo.dob ne  '01-01-1900'}">
                ${contactinfo.dob}
            </c:if>
        </span>
    </td>
    <th scope="row"><spring:message code="sal.text.race" /></th>
    <td><span>${contactinfo.codeName}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.email" /></th>
    <td><span>${contactinfo.email}</span></td>
    <th scope="row"><spring:message code="sal.text.dept" /></th>
    <td><span>${contactinfo.dept}</span></td>
    <th scope="row"><spring:message code="sal.text.post" /></th>
    <td><span>${contactinfo.pos}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.telM" /></th>
    <td><span>${contactinfo.telM1}</span></td>
    <th scope="row"><spring:message code="sal.text.telR" /></th>
    <td><span>${contactinfo.telR}</span></td>
    <th scope="row"><spring:message code="sal.text.telO" /></th>
    <td><span>${contactinfo.telO}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.telF" /></th>
    <td>${contactinfo.telf}</td>
    <th scope="row"></th>
    <td></td>
    <th scope="row"></th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->
</article><!-- tap_area end -->
</section><!-- tap_wrap end -->
<!-- ########## Basic Info End ##########  -->
<aside class="title_line mt30"><!-- title_line start -->
<h2><spring:message code="sal.page.title.custBasicInformation" /></h2>
<ul class="right_opt mt10">
    <li><span class="red_text">*<spring:message code="sal.text.compulsoryField" /></span> <span class="brown_text">#<spring:message code="sal.text.compulsoryFieldForIndType" /></span></li>
</ul>
</aside><!-- title_line end -->
<!-- ######### Update Field Start  ######### -->
<form id="updForm"><!-- form start -->
<input type="hidden" value="${result.custId}" name="basicCustId">
<input type="hidden" value="${result.typeId }" name="basicTypeId">
<input type="hidden" value="${result.nric}" name="basicNricOld">
<input type="hidden" value="${result.custTin}" name="basicCustTinOld">
<%-- <input type="hidden" value="${result.eInvFlg}" name="isEInvoiceOld"> --%> <!-- [Celeste] 29-05-2024 : move eInvoice flag to bill group -->
<!-- <input type="hidden" id = "isEInvoiceNew" name="isEInvoiceNew"> --> <!-- [Celeste] 29-05-2024 : move eInvoice flag to bill group -->
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:135px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.custType" /></th>
    <td colspan="3">
    <select name="basicCmbCustTypeId" id="basicCmbCustTypeId" class="disabled w100p" ></select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.companyType" /><span class="must">*</span></th>
    <td><select name="basicCmbCorpTypeId" id="basicCmbCorpTypeId" class="disabled w100p" ></select></td>
    <th scope="row"><spring:message code="sal.text.nricCompanyNo" /><span class="must">*</span></th>
    <td>
    <input type="text" title="" placeholder=""   value="${result.nric}"  name = "basicNric" id="basicNric"/>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.custName" /><span class="must">*</span></th>
    <td>
    <input type="text" title="" placeholder="" class="w100p"  name="basicName" value="${result.name }" id="basicName" maxlength="70"/> <!-- name  -->
    </td>
    <th scope="row"><spring:message code="sal.text.nationality" /> <span class="brown_text">#</span></th>
    <td>
        <c:choose>
            <c:when test="${SESSION_INFO.roleId == '250'}">
                <select class="w100p" id="basicCmdNationTypeId" name="basicCmdNationTypeId"></select>
            </c:when>
            <c:when test="${SESSION_INFO.roleId == '179'}">
                <select class="w100p" id="basicCmdNationTypeId" name="basicCmdNationTypeId"></select>
            </c:when>
             <c:when test="${SESSION_INFO.roleId == '105'}">
                <select class="w100p" id="basicCmdNationTypeId" name="basicCmdNationTypeId"></select>
            </c:when>
             <c:when test="${SESSION_INFO.roleId == '97'}">
                <select class="w100p" id="basicCmdNationTypeId" name="basicCmdNationTypeId"></select>
            </c:when>
             <c:when test="${SESSION_INFO.roleId == '212'}">
                <select class="w100p" id="basicCmdNationTypeId" name="basicCmdNationTypeId"></select>
            </c:when>
             <c:when test="${SESSION_INFO.roleId == '343'}">
                <select class="w100p" id="basicCmdNationTypeId" name="basicCmdNationTypeId"></select>
            </c:when>
             <c:when test="${SESSION_INFO.roleId == '344'}">
                <select class="w100p" id="basicCmdNationTypeId" name="basicCmdNationTypeId"></select>
            </c:when>
            <c:otherwise>
                <select class="disabled w100p" disabled="disabled" id="basicCmdNationTypeId" name="basicCmdNationTypeId"></select>
            </c:otherwise>
        </c:choose>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.dob" /> <span class="brown_text">#</span></th>
    <td>
    <input type="text" title="Create start Date" value="${result.dob}" name="basicDob" id="basicDob"  readonly="readonly"/>
    </td>
    <th scope="row"><spring:message code="sal.text.passportExpire" /></th>
    <td>
    <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date"  value="${result.pasSportExpr}" name="basicPasSportExpr" readonly="readonly"/>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.gender" /> <span class="brown_text">#</span></th>
    <td>
    <label><input type="radio" id="basicGender" name="basicGender"  <c:if test="${result.gender ne 'F'}">checked</c:if>  value="M"/><span>Male</span></label>
    <label><input type="radio" id="basicGender" name="basicGender"  <c:if test="${result.gender eq 'F'}">checked</c:if> value="F" /><span>Female</span></label>
    </td>
    <th scope="row"><spring:message code="sal.text.visaExpire" /></th>
    <td>
    <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" value="${result.visaExpr }" name="basicVisaExpr" readonly="readonly"/>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.race" /> <span class="brown_text">#</span></th>
    <td>
    <select class="w100p" id="basicCmdRaceTypeId" name="basicRaceId"></select>
    </td>
    <th scope="row"><spring:message code="sal.text.email" /></th>
    <td>
    <input type="text" title="" placeholder="" class="w100p"  value="${result.email}" name="basicEmail" id="basicEmail"/>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.tin" /></th>
    <td>
        <input type="text" title="" placeholder="" class="w100p"  value="${result.custTin}" name="basicCustTin" id="basicCustTin" maxlength=14 onkeydown='return /[a-zA-Z0-9]/i.test(event.key)'/>
    </td>
    <th scope="row"><spring:message code="sal.text.sstRegistrationNo" /></th>
    <%-- <td><input type="text" title="" placeholder="" class="w100p"  value="${result.sstRgistNo}" name="basicSstRegNo" id="basicSstRegNo" maxlength=35 onkeydown='return /[a-zA-Z0-9]/i.test(event.key)'/></td> --%>
    <td><input type="text" title="" placeholder="" class="w100p"  value="${result.sstRgistNo}" name="basicSstRegNo" id="basicSstRegNo" maxlength=35 /></td>
    </td>
</tr>
<tr>
    <th scope="row"></th>
    <td></td>
    <!-- [Celeste] 29-05-2024 : move eInvoice flag to bill group -->
    <%-- <th scope="row"><spring:message code="sal.text.eInvoicFlag" /></th>
    <td>
        <c:choose>
        <c:when test="${result.eInvFlg eq '1'}">
            <input id="isEInvoice" name="isEInvoice" type="checkbox"  checked/>
        </c:when>
        <c:otherwise>
            <input id="isEInvoice" name="isEInvoice" type="checkbox" />
        </c:otherwise>
        </c:choose>
    </td> --%>
    <th scope="row"></th>
    <td></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.remark" /></th>
    <td colspan="3"><textarea cols="20" placeholder="Remarks" rows="5" name="basicRem">${result.rem}</textarea></td>
</tr>
</tbody>
</table><!-- table end -->
</form><!-- form end -->
<div id="_basicUpdBtn">
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#none" id="_updBtn"><spring:message code="sal.btn.update" /></a></p></li>
</ul>
</div>
</section><!-- pop_body end -->
</div>