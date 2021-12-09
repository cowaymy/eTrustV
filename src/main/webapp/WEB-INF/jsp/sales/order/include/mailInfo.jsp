<script type="text/javaScript" language="javascript">
	//Masking pen (display last 4)
	var oriNric = '${orderDetail.mailingInfo.mailCntNric}';
	var oriMobileNo = '${orderDetail.mailingInfo.mailCntTelM}';
	var oriEmail = '${orderDetail.mailingInfo.mailCntEmail}';
	var oriFaxNo = '${orderDetail.mailingInfo.mailCntTelF}';
	var oriOfficeNo = '${orderDetail.mailingInfo.mailCntTelO}';
	var oriHouseNo = '${orderDetail.mailingInfo.mailCntTelR}';
	var oriMainEmail = '${orderDetail.mailingInfo.mailCntEmail}';
	var oriAddEmail = '${orderDetail.mailingInfo.mailCntEmailAdd}';

	$(document).ready(function(){

	    var maskedNric = oriNric.substr(-4).padStart(oriNric.length, '*');
	    var maskedMobileNo = oriMobileNo.replace(/(?<=\d\d\d)\d(?=\d{4})/g, "*");
	    var maskedEmail = "";

	    var prefix= oriEmail.substring(0, oriEmail .lastIndexOf("@"));
	    var postfix= oriEmail.substring(oriEmail .lastIndexOf("@"));
	    for(var i=0; i<prefix.length; i++){
	        if(i == 0 || i == prefix.length - 1) {
	            maskedEmail = maskedEmail + prefix[i].toString();
	        }
	        else {
	            maskedEmail = maskedEmail + "*";
	        }
	    }
	    maskedEmail =maskedEmail +postfix;

	    var maskedFaxNo = oriFaxNo.replace(/(?<=\d\d\d)\d(?=\d{4})/g, "*");
	    var maskedOfficeNo= oriOfficeNo.replace(/(?<=\d\d)\d(?=\d{4})/g, "*");
	    var maskedHouseNo= oriHouseNo.replace(/(?<=\d\d)\d(?=\d{4})/g, "*");
	    var maskedMainEmail = "";

	    var prefix= oriMainEmail.substring(0, oriMainEmail .lastIndexOf("@"));
        var postfix= oriMainEmail.substring(oriMainEmail .lastIndexOf("@"));
        for(var i=0; i<prefix.length; i++){
            if(i == 0 || i == prefix.length - 1) {
            	maskedMainEmail = maskedMainEmail + prefix[i].toString();
            }
            else {
            	maskedMainEmail = maskedMainEmail + "*";
            }
        }
        maskedMainEmail =maskedMainEmail +postfix;

        var maskedAddEmail = "";

        var prefix= oriAddEmail.substring(0, oriAddEmail .lastIndexOf("@"));
        var postfix= oriAddEmail.substring(oriAddEmail .lastIndexOf("@"));
        for(var i=0; i<prefix.length; i++){
            if(i == 0 || i == prefix.length - 1) {
            	maskedAddEmail = maskedAddEmail + prefix[i].toString();
            }
            else {
            	maskedAddEmail = maskedAddEmail + "*";
            }
        }
        maskedAddEmail =maskedAddEmail +postfix;

        if(oriNric.replace(/\s/g,"") != "")
        {
        	$("#spanMailNric").html(maskedNric);
            // Appear NRIC on hover over field
            $("#spanMailNric").hover(function() {
                $("#spanMailNric").html(oriNric);
            }).mouseout(function() {
                $("#spanMailNric").html(maskedNric);
            });
        }
        else{
        	$("#imgHoverNric").hide();
        }
        if(oriMobileNo.replace(/\s/g,"") != "")
        {
        	$("#spanMailMobileNo").html(maskedMobileNo);
            // Appear Mobile No on hover over field
            $("#spanMailMobileNo").hover(function() {
                $("#spanMailMobileNo").html(oriMobileNo);
            }).mouseout(function() {
                $("#spanMailMobileNo").html(maskedMobileNo);
            });
        }else{
            $("#imgHoverMobileNo").hide();
        }
        if(oriEmail.replace(/\s/g,"") != "")
        {
        	$("#spanMailEmail").html(maskedEmail);
            // Appear Email on hover over field
            $("#spanMailEmail").hover(function() {
                $("#spanMailEmail").html(oriEmail);
            }).mouseout(function() {
                $("#spanMailEmail").html(maskedEmail);
            });
        }else{
            $("#imgHoverEmail").hide();
        }
        if(oriFaxNo.replace(/\s/g,"") != "")
        {
        	$("#spanMailFaxNo").html(maskedFaxNo);
            // Appear Fax No on hover over field
            $("#spanMailFaxNo").hover(function() {
                $("#spanMailFaxNo").html(oriFaxNo);
            }).mouseout(function() {
                $("#spanMailFaxNo").html(maskedFaxNo);
            });
        }
        else{
       	   $("#imgHoverFax").hide();
        }
        if(oriOfficeNo.replace(/\s/g,"") != "")
        {
		    $("#spanMailOfficeNo").html(maskedOfficeNo);
		    // Appear Office No on hover over field
		    $("#spanMailOfficeNo").hover(function() {
		        $("#spanMailOfficeNo").html(oriOfficeNo);
		    }).mouseout(function() {
		        $("#spanMailOfficeNo").html(maskedOfficeNo);
		    });
        }
        else{
        	$("#imgHoverOfficeNo").hide();
        }
        if(oriHouseNo.replace(/\s/g,"") != "")
        {
		    $("#spanMailHouseNo").html(maskedHouseNo);
		    // Appear House No on hover over field
		    $("#spanMailHouseNo").hover(function() {
		        $("#spanMailHouseNo").html(oriHouseNo);
		    }).mouseout(function() {
		        $("#spanMailHouseNo").html(maskedHouseNo);
		    });
        }
        else{
                $("#imgHoverHouseNo").hide();
        }
        if(oriMainEmail.replace(/\s/g,"") != "")
        {
		    $("#spanMailMainEmail").html(maskedMainEmail);
		    // Appear House No on hover over field
		    $("#spanMailMainEmail").hover(function() {
		        $("#spanMailMainEmail").html(oriMainEmail);
		    }).mouseout(function() {
		        $("#spanMailMainEmail").html(maskedMainEmail);
		    });
        }
        else{
        	$("#imgHoverMainEmail").hide();
        }
        if(oriAddEmail.replace(/\s/g,"") != "")
        {
		    $("#spanMailAddEmail").html(maskedAddEmail);
		    // Appear House No on hover over field
		    $("#spanMailAddEmail").hover(function() {
		        $("#spanMailAddEmail").html(oriAddEmail);
		    }).mouseout(function() {
		        $("#spanMailAddEmail").html(maskedAddEmail);
		    });
        }
        else{
        	$("#imgHoverAddEmail").hide();
        }
	});
</script>

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:100px" />
    <col style="width:*" />
    <col style="width:120px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.addressDetail" /></th>
    <td colspan="3"><span>${orderDetail.mailingInfo.addrDtl}</span></td>
    <th scope="row"><spring:message code="sal.text.postCode" /></th>
    <td><span>${orderDetail.mailingInfo.mailPostCode}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.street" /></th>
    <td colspan="3"><span>${orderDetail.mailingInfo.street}</span></td>
    <th scope="row"><spring:message code="sal.text.city" /></th>
    <td><span>${orderDetail.mailingInfo.mailCity}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.area" /></th>
    <td colspan="3"><span>${orderDetail.mailingInfo.mailArea}</span></td>
    <th scope="row"><spring:message code="sal.text.state" /></th>
    <td><span>${orderDetail.mailingInfo.mailState}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.billingGroup" /></th>
    <td><span>${orderDetail.mailingInfo.billGrpNo}</span></td>
    <th scope="row"><spring:message code="sal.text.billingType" /></th>
    <td>
    <label>
  <c:choose>
    <c:when test="${orderDetail.mailingInfo.billSms != 0}">
       <input type="checkbox" onClick="return false" checked/>
       <span class="txt_box"><spring:message code="sal.text.sms" /><i>${orderDetail.mailingInfo.mailCntTelM}</i></span>
    </c:when>
    <c:otherwise>
       <input type="checkbox" onClick="return false"/>
       <span><spring:message code="sal.text.sms" /></span>
    </c:otherwise>
  </c:choose>
    </label>
    <label>
  <c:choose>
    <c:when test="${orderDetail.mailingInfo.billPost != 0}">
       <input type="checkbox" onClick="return false" checked/>
       <span class="txt_box"><spring:message code="sal.text.post" /><i>${orderDetail.mailingInfo.fullAddress}</i></span>
    </c:when>
    <c:otherwise>
       <input type="checkbox" onClick="return false"/>
       <span><spring:message code="sal.text.post" /></span>
    </c:otherwise>
  </c:choose>
    </label>
    <label>
  <c:choose>
    <c:when test="${orderDetail.mailingInfo.billState != 0}">
       <input type="checkbox" onClick="return false" checked/>
       <span class="txt_box"><spring:message code="sal.text.eStatement" /><i>${orderDetail.mailingInfo.billStateEmail}</i></span>
    </c:when>
    <c:otherwise>
       <input type="checkbox" onClick="return false"/>
       <span><spring:message code="sal.text.eStatement" /></span>
    </c:otherwise>
  </c:choose>
     </label>
    </td>
    <th scope="row"><spring:message code="sal.text.country" /></th>
    <td><span>${orderDetail.mailingInfo.mailCnty}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.email" /></th>
    <td><a href="#" class="search_btn" id="imgHoverMainEmail"><img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" /></a>
        <span id=spanMailMainEmail>${orderDetail.mailingInfo.mailCntEmail}</span>
    </td>
    <th scope="row"><spring:message code="pay.head.additionalEmail" /></th>
    <td><a href="#" class="search_btn" id="imgHoverAddEmail"><img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" /></a>
        <span id="spanMailAddEmail">${orderDetail.mailingInfo.mailCntEmailAdd}</span>
    </td>
    <th scope="row"></th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->

<table class="type1 mt40"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:110px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.title.text.contactName" /></th>
    <td colspan="3"><span>${orderDetail.mailingInfo.mailCntName}</span></td>
    <th scope="row"><spring:message code="sal.text.gender" /></th>
    <td><span>${orderDetail.mailingInfo.mailCntGender}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.contactNRIC" /></th>
    <td><a href="#" class="search_btn" id="imgHoverNric"><img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" /></a>
        <span id="spanMailNric">${orderDetail.mailingInfo.mailCntNric}</span>
    </td>
    <th scope="row"><spring:message code="sal.text.email" /></th>
    <td><a href="#" class="search_btn" id="imgHoverEmail"><img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" /></a>
        <span id="spanMailEmail">${orderDetail.mailingInfo.mailCntEmail}</span>
    </td>
    <th scope="row"><spring:message code="sal.text.faxNo" /></th>
    <td><a href="#" class="search_btn" id="imgHoverFax"><img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" /></a>
        <span id="spanMailFaxNo">${orderDetail.mailingInfo.mailCntTelF}</span>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.mobileNo" /></th>
    <td><a href="#" class="search_btn" id="imgHoverMobileNo"><img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" /></a>
        <span id="spanMailMobileNo">${orderDetail.mailingInfo.mailCntTelM}</span>
    </td>
    <th scope="row"><spring:message code="sal.text.officeNo" /></th>
        <td><a href="#" class="search_btn" id="imgHoverOfficeNo"><img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" /></a>
    <span id="spanMailOfficeNo">${orderDetail.mailingInfo.mailCntTelO}</span>
    </td>
    <th scope="row"><spring:message code="sal.title.text.houseNo" /></th>
    <td><a href="#" class="search_btn" id="imgHoverHouseNo"><img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" /></a>
        <span id="spanMailHouseNo">${orderDetail.mailingInfo.mailCntTelR}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.post" /></th>
    <td><span>${orderDetail.mailingInfo.mailCntPost}</span></td>
    <th scope="row"><spring:message code="sal.text.dept" /></th>
    <td><span>${orderDetail.mailingInfo.mailCntDept}</span></td>
    <th scope="row"></th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->