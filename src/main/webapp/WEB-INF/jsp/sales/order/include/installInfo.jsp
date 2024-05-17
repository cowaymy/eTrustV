<script type="text/javaScript" language="javascript">
    //Masking pen (display last 4)
    var oriInstNric = "${orderDetail.installationInfo.instCntNric}";
    var oriInstMobileNo = "${orderDetail.installationInfo.instCntTelM}";
    var oriInstEmail = "${orderDetail.installationInfo.instCntEmail}";
    var oriInstFaxNo = "${orderDetail.installationInfo.instCntTelF}";
    var oriInstOfficeNo = "${orderDetail.installationInfo.instCntTelO}";
    var oriInstHouseNo = "${orderDetail.installationInfo.instCntTelR}";

    $(document).ready(function(){

        var maskedNric = oriInstNric.substr(-4).padStart(oriInstNric.length, "*");
        //var maskedMobileNo = oriInstMobileNo.replace(/(?<=\d\d\d)\d(?=\d{4})/g, "*");
        var maskedMobileNo = oriInstMobileNo.substr(0,3) + oriInstMobileNo.substr(3,oriInstMobileNo.length-7).replace(/[0-9]/g, "*") + oriInstMobileNo.substr(-4);
        var maskedEmail = "";

        var prefix= oriInstEmail.substr(0, oriInstEmail.lastIndexOf("@"));
        var postfix= oriInstEmail.substr(oriInstEmail.lastIndexOf("@"));
        for(var i=0; i<prefix.length; i++){
            if(i == 0 || i == prefix.length - 1) {
                maskedEmail = maskedEmail + prefix[i].toString();
            }
            else {
                maskedEmail = maskedEmail + "*";
            }
        }
        maskedEmail =maskedEmail +postfix;

        /* var maskedFaxNo = oriInstFaxNo.replace(/(?<=\d\d\d)\d(?=\d{4})/g, "*");
        var maskedOfficeNo= oriInstOfficeNo.replace(/(?<=\d\d)\d(?=\d{4})/g, "*");
        var maskedHouseNo= oriInstHouseNo.replace(/(?<=\d\d)\d(?=\d{4})/g, "*"); */

        var maskedFaxNo = oriInstFaxNo.substr(0,3) + oriInstFaxNo.substr(3,oriInstFaxNo.length-7).replace(/[0-9]/g, "*") + oriInstFaxNo.substr(-4);
        var maskedOfficeNo = oriInstOfficeNo.substr(0,2) + oriInstOfficeNo.substr(3,oriInstOfficeNo.length-7).replace(/[0-9]/g, "*") + oriInstOfficeNo.substr(-4);
        var maskedHouseNo = oriInstHouseNo.substr(0,2) + oriInstHouseNo.substr(3,oriInstHouseNo.length-7).replace(/[0-9]/g, "*") + oriInstHouseNo.substr(-4);

        if(oriInstNric.replace(/\s/g,"") != "")
        {
            $("#spanInstNric").html(maskedNric);
            // Appear NRIC on hover over field
            $("#spanInstNric").hover(function() {
                $("#spanInstNric").html(oriInstNric);
            }).mouseout(function() {
                $("#spanInstNric").html(maskedNric);
            });
        }
        else{
            $("#imgHoverInstNric").hide();
        }
        if(oriInstMobileNo.replace(/\s/g,"") != "")
        {
            $("#spanInstMobileNo").html(maskedMobileNo);
            // Appear Mobile No on hover over field
            $("#spanInstMobileNo").hover(function() {
                $("#spanInstMobileNo").html(oriInstMobileNo);
            }).mouseout(function() {
                $("#spanInstMobileNo").html(maskedMobileNo);
            });
        }
        else{
            $("#imgHoverInstMobileNo").hide();
        }
        if(oriInstEmail.replace(/\s/g,"") != "")
        {
            $("#spanInstEmail").html(maskedEmail);
            // Appear Email on hover over field
            $("#spanInstEmail").hover(function() {
                $("#spanInstEmail").html(oriInstEmail);
            }).mouseout(function() {
                $("#spanInstEmail").html(maskedEmail);
            });
        }
        else{
            $("#imgHoverInstEmail").hide();
        }
        if(oriInstFaxNo.replace(/\s/g,"") != "")
        {
            $("#spanInstFaxNo").html(maskedFaxNo);
            // Appear Fax No on hover over field
            $("#spanInstFaxNo").hover(function() {
                $("#spanInstFaxNo").html(oriInstFaxNo);
            }).mouseout(function() {
                $("#spanInstFaxNo").html(maskedFaxNo);
            });
        }
        else{
            $("#imgHoverInstFaxNo").hide();
        }
        if(oriInstOfficeNo.replace(/\s/g,"") != "")
        {
            $("#spanInstOfficeNo").html(maskedOfficeNo);
            // Appear Office No on hover over field
            $("#spanInstOfficeNo").hover(function() {
                $("#spanInstOfficeNo").html(oriInstOfficeNo);
            }).mouseout(function() {
                $("#spanInstOfficeNo").html(maskedOfficeNo);
            });
        }
        else{
            $("#imgHoverInstOfficeNo").hide();
        }
        if(oriInstHouseNo.replace(/\s/g,"") != "")
        {
            $("#spanInstHouseNo").html(maskedHouseNo);
            // Appear House No on hover over field
            $("#spanInstHouseNo").hover(function() {
                $("#spanInstHouseNo").html(oriInstHouseNo);
            }).mouseout(function() {
                $("#spanInstHouseNo").html(maskedHouseNo);
            });
        }
        else{
            $("#imgHoverInstHouseNo").hide();
        }

    });

    function fn_atchViewDown(fileGrpId, fileId) {
        var data = {
            atchFileGrpId : fileGrpId,
            atchFileId : fileId
        };

        if(fileGrpId=="0"){
        	Common.alert("No file to view.")
        	return false;
        }

        Common.ajax("GET", "/eAccounting/webInvoice/getAttachmentInfo.do", data, function(result) {
            var fileSubPath = result.fileSubPath;

            fileSubPath = fileSubPath.replace('\', '/'');
            window.open("/file/fileDownWeb.do?subPath=" + fileSubPath + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
        });
    }
</script>

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.addressDetail" /></th>
    <td colspan="3"><span>${orderDetail.installationInfo.instAddrDtl}</span></td>
    <th scope="row"><spring:message code="sal.text.postCode" /></th>
    <td><span>${orderDetail.installationInfo.instPostcode}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.street" /></th>
    <td colspan="3"><span>${orderDetail.installationInfo.instStreet}</span></td>
    <th scope="row"><spring:message code="sal.text.city" /></th>
    <td><span>${orderDetail.installationInfo.instCity}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.area" /></th>
    <td colspan="3"><span>${orderDetail.installationInfo.instArea}</span></td>
    <th scope="row"><spring:message code="sal.text.state" /></th>
    <td><span>${orderDetail.installationInfo.instState}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.perferInstDate" /></th>
    <td><span>${orderDetail.installationInfo.preferInstDt}</span></td>
    <th scope="row"><spring:message code="sal.title.text.perferInstTime" /></th>
    <td><span>${orderDetail.installationInfo.preferInstTm}</span></td>
    <th scope="row"><spring:message code="sal.text.country" /></th>
    <td><span>${orderDetail.installationInfo.instCountry}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.latestCallDt" /></th>
    <td><span>${orderDetail.callLog[0].callDt} </span></td>
    <th scope="row"><spring:message code="sal.text.latestCallTm" /></th>
    <td colspan="3"><span>${orderDetail.callLog[0].callTm} </span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.instruct" /></th>
    <td colspan="5"><span>${orderDetail.installationInfo.instct}</span></td>
</tr>
<%-- <tr>
    <th scope="row"><spring:message code="sal.text.dscVerifiRem" /></th>
    <td colspan="5"><span>${orderDetail.installationInfo.vrifyRem}</span></td>
</tr> --%>
<tr>
    <th scope="row"><spring:message code="sal.title.text.dscBrnch" /></th>
    <td><span>(${orderDetail.installationInfo.dscCode} )${orderDetail.installationInfo.dscName}</span></td>
    <th scope="row">DSC Code</th>
    <td><span>${orderDetail.installationInfo.dscCode2} ${orderDetail.installationInfo.dscCode2Name}</span></td>
    <th scope="row"><spring:message code="sal.title.text.dscRegion" /></th>
    <td><span>${orderDetail.installationInfo.dscRegion}</span></td>
</tr>
<tr>
<th scope="row"><spring:message code="sal.text.instDt" /></th>
    <td colspan="5"><span>${orderDetail.installationInfo.firstInstallDt}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.ctCd" /></th>
    <td><span>${orderDetail.installationInfo.lastInstallCtCode}</span></td>
    <th scope="row"><spring:message code="sal.text.ctNm" /></th>
    <td colspan="3"><span>${orderDetail.installationInfo.lastInstallCtName}</span></td>
</tr>
<tr>
  <th scope="row"><spring:message code="sal.text.instImg" /></th>
  <td colspan="">
    <ul class="btns">
      <li>
        <p class="btn_grid">
          <a href="#" onClick=
            "{Common.popupDiv('/sales/order/getInstImg.do', { ordNo : '${orderDetail.basicInfo.ordNo}' }, null , true);}"><spring:message code='sys.btn.view' /></a>
        </p>
       </li>
      </ul>
    </td>
    <th scope="row"><spring:message code="service.title.AssignedCT" /></th>
    <td colspan="3"><span>${orderDetail.installationInfo.assignedCt}</span></td>
</tr>
<tr>
  <th scope="row"><spring:message code="service.title.PSILMPRcd" /></th>
  <td colspan="">
    <ul class="btns">
      <li>
        <p class="btn_grid">
          <a href="#" onClick=
            "{Common.popupDiv('/sales/order/getInstAsPSI.do', { ordNo : '${orderDetail.basicInfo.ordNo}' }, null , true);}"><spring:message code='sys.btn.view' /></a>
        </p>
       </li>
      </ul>
    </td>
    <th scope="row"><spring:message code="service.title.AssignedCTMobileNo" /></th>
    <td colspan="3"><span>${orderDetail.installationInfo.assignedCtMobileno}</span></td>
</tr>
<tr>
    <th scope="row">Water Source Type</th>
    <td colspan="5">
    <div>${orderDetail.installationInfo.waterSrcType}</div>
    <br/>
    <ul class="btns">
      <li>
        <p class="btn_grid">
          <a href="#" onClick="fn_atchViewDown(${orderDetail.installationInfo.atchFileGrpId},${orderDetail.installationInfo.atchFileId})"><spring:message code='sys.btn.view' /></a>
        </p>
       </li>
      </ul>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<table class="type1 mt40"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.title.text.contactName" /></th>
    <td colspan="3"><span>${orderDetail.installationInfo.instCntName}</span></td>
    <th scope="row"><spring:message code="sal.text.gender" /></th>
    <td><span>${orderDetail.installationInfo.instCntGender}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.contactNRIC" /></th>
    <td><a href="#" class="search_btn" id="imgHoverInstNric"><img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" /></a>
        <span id="spanInstNric">${orderDetail.installationInfo.instCntNric}</span></td>
    <th scope="row"><spring:message code="sal.text.email" /></th>
    <td><a href="#" class="search_btn" id="imgHoverInstEmail"><img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" /></a>
        <span id="spanInstEmail">${orderDetail.installationInfo.instCntEmail}</span></td>
    <th scope="row"><spring:message code="sal.text.faxNo" /></th>
    <td><a href="#" class="search_btn" id="imgHoverInstFaxNo"><img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" /></a>
        <span id="spanInstFaxNo">${orderDetail.installationInfo.instCntTelF}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.mobileNo" /></th>
    <td><a href="#" class="search_btn" id="imgHoverInstMobileNo"><img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" /></a>
        <span id=spanInstMobileNo>${orderDetail.installationInfo.instCntTelM}</span></td>
    <th scope="row"><spring:message code="sal.text.officeNo" /></th>
    <td><a href="#" class="search_btn" id="imgHoverInstOfficeNo"><img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" /></a>
        <span id="spanInstOfficeNo">${orderDetail.installationInfo.instCntTelO}</span></td>
    <th scope="row"><spring:message code="sal.title.text.houseNo" /></th>
    <td><a href="#" class="search_btn" id="imgHoverInstHouseNo"><img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" /></a>
        <span id="spanInstHouseNo">${orderDetail.installationInfo.instCntTelR}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.post" /></th>
    <td><span>${orderDetail.installationInfo.instCntPost}</span></td>
    <th scope="row"><spring:message code="sal.text.dept" /></th>
    <td><span>${orderDetail.installationInfo.instCntDept}</span></td>
    <th scope="row"></th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->