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
    doGetCombo('/sales/customer/getNationList', '' , '' ,'basicCmdNationTypeId' , 'S');        // Nationality Combo Box
    doGetCombo('/common/selectCodeList.do', '2', selCodeRaceId ,'basicCmdRaceTypeId', 'S', ''); //cmdRaceTypeId
    //TypeId 에 따른 수정항목 Control
    // individual
    if(selCodeCustId == '964'){
        $("#basicCmbCustTypeId").attr("disabled" , "disabled");
        $("#basicCmbCorpTypeId").attr({"class" : "disabled w100p" , "disabled" : "disabled"});
        $("#basicNric").attr({"class":"readonly w100p","readonly" : "readonly"});
        $("input[name='basicGender']").attr("disabled" , false);
        $("#basicCmdRaceTypeId").attr("disabled" , false);
        $("#basicCmdNationTypeId").attr("disabled" , "disabled");
        $("#basicDob").attr("disabled" , "disabled");
    }
    // company
    if(selCodeCustId == '965'){
        $("#basicCmbCustTypeId").attr("disabled" , "disabled");
        $("#basicCmbCorpTypeId").attr({"class" : "w100p" , "disabled" : false});
        $("#basicNric").attr({"class":"readonly w100p","readonly" : "readonly"});
        $("input[name='basicGender']").attr({"disabled" : "disabled" , "checked" : false});
        $("#basicCmdRaceTypeId").attr({"disabled" : "disabled" , "class":"disabled w100p"});
        $("#basicCmdNationTypeId").attr("disabled" , "disabled");
        $("#basicDob").attr("disabled" , "disabled");
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
                Common.alert("*Please enter Customer Name.");
                return;
            }
            //Race
            if('' == $("#basicCmdRaceTypeId").val() || null == $("#basicCmdRaceTypeId").val()){
                Common.alert("*Please enter Race");
                return;
            }
            //Email 
            if('' != $("#basicEmail").val() && null != $("#basicEmail").val()){
                
                if(FormUtil.checkEmail($("#basicEmail").val()) == true){
                    Common.alert("* Invalid email address.");
                    return;
                 }
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
                    Common.alert("* Invalid email address.");
                    return;
                 }
            }
        }
        
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
        Common.ajax("GET", "/sales/customer/updateCustomerBasicInfoAf.do",$("#updForm").serialize(), function(result) {
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
</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<!-- getParams  -->
<input type="hidden" value="${result.typeId }" id="selCodeCustId"> <!-- TypeId : 964(Individual) / 965(Company)  --> 
<input type="hidden" value="${result.corpTypeId}" id="selCodeCorpId">
<input type="hidden" value="${result.nation }" id="selCodeNation">
<input type="hidden" value="${result.raceId }" id="selCodeRaceId">

<header class="pop_header"><!-- pop_header start -->
<h1>Customer Basic Info Maintenance</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="_close" onclick="javascript: fn_closeFunc()">CLOSE</a></p></li>
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
    <th scope="row">EDIT Type</th>
    <td>
    <select id="_editCustomerInfo">
        <option value="1" <c:if test="${selectParam eq 1}">selected</c:if>>Edit Basic Info</option>
        <option value="2" <c:if test="${selectParam eq 2}">selected</c:if>>Edit Customer Address</option>
        <option value="3" <c:if test="${selectParam eq 3}">selected</c:if>>Edit Contact Info</option>
        <option value="4" <c:if test="${selectParam eq 4}">selected</c:if>>Edit Bank Account</option>
        <option value="5" <c:if test="${selectParam eq 5}">selected</c:if>>Edit Credit Card</option>
        <option value="6" <c:if test="${selectParam eq 6}">selected</c:if>>Edit Basic Info(Limit)</option>
    </select>
    <p class="btn_sky"><a href="#" id="_confirm">Confirm</a></p>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Customer Information</h2>
</aside><!-- title_line end -->

<section class="tap_wrap mt10"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on">Basic Info</a></li>
    <li><a href="#">Main Address</a></li>
    <li><a href="#">Main Contact</a></li>
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
    <th scope="row">Customer ID</th>
    <td><span>${result.custId}</span></td>
    <th scope="row">Customer Type</th>
    <td>
        <span> 
                ${result.codeName1}
                <!-- not Individual -->  
                <c:if test="${ result.typeId ne 964}">
                    (${result.codeName})
                </c:if>
            </span>
    </td>
    <th scope="row">Create At</th>
    <td>${result.crtDt}</td>
</tr>
<tr>
    <th scope="row">Customer Name</th>
    <td colspan="3">${result.name}</td>
    <th scope="row">Create By</th>
    <td>
        <c:if test="${result.crtUserId ne 0}">
                ${result.userName}
            </c:if>
    </td>
</tr>
<tr>
    <th scope="row">NRIC/Company Number</th>
    <td><span>${result.nric}</span></td>
    <th scope="row">GST Registration No</th>
    <td>${result.gstRgistNo}</td>
    <th scope="row">Update By</th>
    <td>${result.userName1}</td>
</tr>
<tr>
    <th scope="row">Email</th>
    <td><span>${result.email}</span></td>
    <th scope="row">Nationality</th>
    <td>${result.cntyName}</td>
    <th scope="row">Update At</th>
    <td>${result.updDt}</td>
</tr>
<tr>
    <th scope="row">Gender</th>
    <td><span>${result.gender}</span></td>
    <th scope="row">DOB</th>
    <td>
        <c:if test="${result.dob ne '01-01-1900'}">
                ${result.dob}
        </c:if>
    </td>
    <th scope="row">Race</th>
    <td>${result.codeName2 }</td>
</tr>
<tr>
    <th scope="row">Passport Expire</th>
    <td><span>${result.pasSportExpr}</span></td>
    <th scope="row">Visa Expire</th>
    <td>${result.visaExpr}</td>
    <th scope="row">VA Number</th>
    <td>${result.custVaNo}</td>
</tr>
<tr>
    <th scope="row">Remark</th>
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
    <th scope="row">Full Address</th>
    <td><span>${addresinfo.fullAddress}</span></td>
</tr>
<tr>
    <th scope="row">Remark</th>
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
    <th scope="row">Name</th>
    <td><span>${contactinfo.name1}</span></td>
    <th scope="row">Initial</th>
    <td><span>${contactinfo.code}</span></td>
    <th scope="row">Genders</th>
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
    <th scope="row">NRIC</th>
    <td><span>${contactinfo.nric}</span></td>
    <th scope="row">DOB</th>
    <td>
        <span>
            <c:if test="${contactinfo.dob ne  '01-01-1900'}">
                ${contactinfo.dob}
            </c:if> 
        </span>
    </td>
    <th scope="row">Race</th>
    <td><span>${contactinfo.codeName}</span></td>
</tr>
<tr>
    <th scope="row">Email</th>
    <td><span>${contactinfo.email}</span></td>
    <th scope="row">Department</th>
    <td><span>${contactinfo.dept}</span></td>
    <th scope="row">Post</th>
    <td><span>${contactinfo.pos}</span></td>
</tr>
<tr>
    <th scope="row">Tel (Mobile)</th>
    <td><span>${contactinfo.telM1}</span></td>
    <th scope="row">Tel (Residence)</th>
    <td><span>${contactinfo.telR}</span></td>
    <th scope="row">Tel (Office)</th>
    <td><span>${contactinfo.telO }</span></td>
</tr>
<tr>
    <th scope="row">Tel (Fax)</th>
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
<h2>Customer Basic Information</h2>
<ul class="right_opt mt10">
    <li><span class="red_text">*Compulsory Field</span> <span class="brown_text">#Compulsory Field(For Indvidual Type)</span></li>
</ul>
</aside><!-- title_line end -->
<!-- ######### Update Field Start  ######### -->
<form id="updForm"><!-- form start -->
<input type="hidden" value="${result.custId}" name="basicCustId">
<input type="hidden" value="${result.typeId }" name="basicTypeId">
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
    <th scope="row">Customer Type</th>
    <td colspan="3">
    <select name="basicCmbCustTypeId" id="basicCmbCustTypeId" class="disabled w100p" ></select>
    </td>
</tr>
<tr>
    <th scope="row">Company Type<span class="must">*</span></th> 
    <td><select name="basicCmbCorpTypeId" id="basicCmbCorpTypeId" class="disabled w100p" ></select></td> 
    <th scope="row">NRIC/Company No<span class="must">*</span></th>
    <td>
    <input type="text" title="" placeholder=""   value="${result.nric}" id="basicNric"/>
    </td>
</tr>
<tr>
    <th scope="row">Customer Name<span class="must">*</span></th>
    <td>
    <input type="text" title="" placeholder="" class="w100p"  name="basicName" value="${result.name }" id="basicName" maxlength="70"/> <!-- name  -->
    </td>
    <th scope="row">Nationality <span class="brown_text">#</span></th>
    <td>
        <select class="disabled w100p" disabled="disabled" id="basicCmdNationTypeId" name="basicCmdNationTypeId"></select>
    </td>
</tr>
<tr>
    <th scope="row">DOB <span class="brown_text">#</span></th>
    <td>
    <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date"   value="${result.dob}" name="basicDob" id="basicDob" readonly="readonly"/>
    </td>
    <th scope="row">Passport Expire</th>
    <td>
    <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date"  value="${result.pasSportExpr}" name="basicPasSportExpr" readonly="readonly"/>
    </td>
</tr>
<tr>
    <th scope="row">Gender <span class="brown_text">#</span></th>
    <td>
    <label><input type="radio" name="basicGender"  <c:if test="${result.gender ne 'F'}">checked</c:if>  value="M"/><span>Male</span></label>
    <label><input type="radio" name="basicGender"  <c:if test="${result.gender eq 'F'}">checked</c:if> value="F" /><span>Female</span></label>
    </td>
    <th scope="row">Visa Expire</th>
    <td>
    <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" value="${result.visaExpr }" name="basicVisaExpr" readonly="readonly"/>
    </td>
</tr>
<tr>
    <th scope="row">Race <span class="brown_text">#</span></th>
    <td>
    <select class="w100p" id="basicCmdRaceTypeId" name="basicRaceId"></select>
    </td>
    <th scope="row">Email</th>
    <td>
    <input type="text" title="" placeholder="" class="w100p"  value="${result.email}" name="basicEmail" id="basicEmail"/>
    </td>
</tr>
<tr>
    <th scope="row">Remarks</th>
    <td colspan="3"><textarea cols="20" placeholder="Remarks" rows="5" name="basicRem">${result.rem}</textarea></td>
</tr>
</tbody>
</table><!-- table end -->
</form><!-- form end -->
<div id="_basicUpdBtn">
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#none" id="_updBtn">Update</a></p></li>
</ul>
</div>
</section><!-- pop_body end -->
</div>