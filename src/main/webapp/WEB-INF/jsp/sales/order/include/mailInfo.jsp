<script type="text/javaScript" language="javascript">
	//Masking pen (display last 4)
	var oriMailNric = "${orderDetail.mailingInfo.mailCntNric}";
	var oriMailMobileNo = "${orderDetail.mailingInfo.mailCntTelM}";
	var oriMailEmail = "${orderDetail.mailingInfo.mailCntEmail}";
	var oriMailFaxNo = "${orderDetail.mailingInfo.mailCntTelF}";
	var oriMailOfficeNo = "${orderDetail.mailingInfo.mailCntTelO}";
	var oriMailHouseNo = "${orderDetail.mailingInfo.mailCntTelR}";
	var oriMailMainEmail = "${orderDetail.mailingInfo.mailCntEmail}";
	var oriMailAddEmail = "${orderDetail.mailingInfo.mailCntEmailAdd}";

	$(document).ready(function(){

	    var maskedNric = oriMailNric.substr(-4).padStart(oriMailNric.length, '*');
	    /* var maskedMobileNo = oriMailMobileNo.replace(/(?<=\d\d\d)\d(?=\d{4})/g, "*"); */
	    var maskedMobileNo = oriMailMobileNo.substr(0,3) + oriMailMobileNo.substr(3,oriMailMobileNo.length-7).replace(/[0-9]/g, "*") + oriMailMobileNo.substr(-4);
	    var maskedEmail = "";

	    var prefix= oriMailEmail.substring(0, oriMailEmail .lastIndexOf("@"));
	    var postfix= oriMailEmail.substring(oriMailEmail .lastIndexOf("@"));
	    for(var i=0; i<prefix.length; i++){
	        if(i == 0 || i == prefix.length - 1) {
	            maskedEmail = maskedEmail + prefix[i].toString();
	        }
	        else {
	            maskedEmail = maskedEmail + "*";
	        }
	    }
	    maskedEmail =maskedEmail +postfix;

	    /* var maskedFaxNo = oriMailFaxNo.replace(/(?<=\d\d\d)\d(?=\d{4})/g, "*");
	    var maskedOfficeNo= oriMailOfficeNo.replace(/(?<=\d\d)\d(?=\d{4})/g, "*");
	    var maskedHouseNo= oriMailHouseNo.replace(/(?<=\d\d)\d(?=\d{4})/g, "*"); */
	    var maskedFaxNo = oriMailFaxNo.substr(0,3) + oriMailFaxNo.substr(3,oriMailFaxNo.length-7).replace(/[0-9]/g, "*") + oriMailFaxNo.substr(-4);
        var maskedOfficeNo = oriMailOfficeNo.substr(0,2) + oriMailOfficeNo.substr(3,oriMailOfficeNo.length-7).replace(/[0-9]/g, "*") + oriMailOfficeNo.substr(-4);
        var maskedHouseNo = oriMailHouseNo.substr(0,2) + oriMailHouseNo.substr(3,oriMailHouseNo.length-7).replace(/[0-9]/g, "*") + oriMailHouseNo.substr(-4);
	    var maskedMainEmail = "";

	    var prefix= oriMailMainEmail.substring(0, oriMailMainEmail .lastIndexOf("@"));
        var postfix= oriMailMainEmail.substring(oriMailMainEmail .lastIndexOf("@"));
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

        var prefix= oriMailAddEmail.substring(0, oriMailAddEmail .lastIndexOf("@"));
        var postfix= oriMailAddEmail.substring(oriMailAddEmail .lastIndexOf("@"));
        for(var i=0; i<prefix.length; i++){
            if(i == 0 || i == prefix.length - 1) {
            	maskedAddEmail = maskedAddEmail + prefix[i].toString();
            }
            else {
            	maskedAddEmail = maskedAddEmail + "*";
            }
        }
        maskedAddEmail =maskedAddEmail +postfix;

        if(oriMailNric.replace(/\s/g,"") != "")
        {
        	$("#spanMailNric").html(maskedNric);
            // Appear NRIC on hover over field
            $("#spanMailNric").hover(function() {
                $("#spanMailNric").html(oriMailNric);
            }).mouseout(function() {
                $("#spanMailNric").html(maskedNric);
            });
        }
        else{
        	$("#imgHoverNric").hide();
        }
        if(oriMailMobileNo.replace(/\s/g,"") != "")
        {
        	$("#spanMailMobileNo").html(maskedMobileNo);
            // Appear Mobile No on hover over field
            $("#spanMailMobileNo").hover(function() {
                $("#spanMailMobileNo").html(oriMailMobileNo);
            }).mouseout(function() {
                $("#spanMailMobileNo").html(maskedMobileNo);
            });
        }else{
            $("#imgHoverMobileNo").hide();
        }
        if(oriMailEmail.replace(/\s/g,"") != "")
        {
        	$("#spanMailEmail").html(maskedEmail);
            // Appear Email on hover over field
            $("#spanMailEmail").hover(function() {
                $("#spanMailEmail").html(oriMailEmail);
            }).mouseout(function() {
                $("#spanMailEmail").html(maskedEmail);
            });
        }else{
            $("#imgHoverEmail").hide();
        }
        if(oriMailFaxNo.replace(/\s/g,"") != "")
        {
        	$("#spanMailFaxNo").html(maskedFaxNo);
            // Appear Fax No on hover over field
            $("#spanMailFaxNo").hover(function() {
                $("#spanMailFaxNo").html(oriMailFaxNo);
            }).mouseout(function() {
                $("#spanMailFaxNo").html(maskedFaxNo);
            });
        }
        else{
       	   $("#imgHoverFax").hide();
        }
        if(oriMailOfficeNo.replace(/\s/g,"") != "")
        {
		    $("#spanMailOfficeNo").html(maskedOfficeNo);
		    // Appear Office No on hover over field
		    $("#spanMailOfficeNo").hover(function() {
		        $("#spanMailOfficeNo").html(oriMailOfficeNo);
		    }).mouseout(function() {
		        $("#spanMailOfficeNo").html(maskedOfficeNo);
		    });
        }
        else{
        	$("#imgHoverOfficeNo").hide();
        }
        if(oriMailHouseNo.replace(/\s/g,"") != "")
        {
		    $("#spanMailHouseNo").html(maskedHouseNo);
		    // Appear House No on hover over field
		    $("#spanMailHouseNo").hover(function() {
		        $("#spanMailHouseNo").html(oriMailHouseNo);
		    }).mouseout(function() {
		        $("#spanMailHouseNo").html(maskedHouseNo);
		    });
        }
        else{
                $("#imgHoverHouseNo").hide();
        }
        if(oriMailMainEmail.replace(/\s/g,"") != "")
        {
		    $("#spanMailMainEmail").html(maskedMainEmail);
		    // Appear House No on hover over field
		    $("#spanMailMainEmail").hover(function() {
		        $("#spanMailMainEmail").html(oriMailMainEmail);
		    }).mouseout(function() {
		        $("#spanMailMainEmail").html(maskedMainEmail);
		    });
        }
        else{
        	$("#imgHoverMainEmail").hide();
        }
        if(oriMailAddEmail.replace(/\s/g,"") != "")
        {
		    $("#spanMailAddEmail").html(maskedAddEmail);
		    // Appear House No on hover over field
		    $("#spanMailAddEmail").hover(function() {
		        $("#spanMailAddEmail").html(oriMailAddEmail);
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
    <th scope="row">Receiving Marketing Message</th>
    <td>
    <div style="display:inline-block;width:100%;">
	    <div style="display:inline-block;">
			<c:choose>
			 <c:when test="${orderDetail.basicInfo.receivingMarketingMsgStatus == 1}">
			     <input id="marketMessageYes" type="radio" value="yes" name="marketingMessageSelection" checked disabled/><label for="marketMessageYes">Yes</label>
			  </c:when>
			  <c:otherwise>
			     <input id="marketMessageYes" type="radio" value="yes" name="marketingMessageSelection" disabled/><label for="marketMessageYes">Yes</label>
			  </c:otherwise>
			</c:choose>
	    </div>
	      <div style="display:inline-block;">
			<c:choose>
			 <c:when test="${orderDetail.basicInfo.receivingMarketingMsgStatus == 0}">
		    	<input  id="marketMessageNo" type="radio" value="no" name="marketingMessageSelection" checked disabled/><label for="marketMessageNo">No</label>
			  </c:when>
			  <c:otherwise>
		    	<input  id="marketMessageNo" type="radio" value="no" name="marketingMessageSelection" disabled/><label for="marketMessageNo">No</label>
			  </c:otherwise>
			</c:choose>
	    </div>
    </div>
	</td>
</tr>
<tr>
    <th scope="row">E-Invoice</th>
    <td colspan="5">
	    <c:choose>
             <c:when test="${orderDetail.mailingInfo.eInvFlg != 0}">
                 <input type="checkbox" onClick="return false" checked/>
              </c:when>
              <c:otherwise>
                 <input type="checkbox" onClick="return false"/>
              </c:otherwise>
            </c:choose>
    </td>
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