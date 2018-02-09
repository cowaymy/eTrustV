<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
	//popup 크기
	var option = {
	        winName : "popup",
	        width : "950px",   // 창 가로 크기
	        height : "700px",    // 창 세로 크기
	        resizable : "yes", // 창 사이즈 변경. (yes/no)(default : yes)
	        scrollbars : "yes" // 스크롤바. (yes/no)(default : yes)
	};
	
    function fn_orderNoExist(){
        $("#searchOrdDt").show();
    }
    
    function fn_orderNoExist2(){
        $("#searchOrdDt").hide();
        $("#searchOrd").val('');
    }
    
    function fn_orderNoExist3(){
        $("#searchOrdDt").hide();
        $("#searchOrd").val($("#salesOrdId").val());
        $("#singleClose").click();
//        $("#viewForm").attr({
//            "target" : "_self",
//            "action" : getContextPath() + "/sales/order/orderInvestList.do"
//        }).submit();
//        fn_orderInvestigationListAjax();
        Common.popupDiv("/sales/order/orderInvestInfoPop.do", $("#popForm").serializeJSON(), null, true, 'dtPop');
    }
    
    $(document).ready(function(){
    	//input setting
        setInputFile2();
    	
        $("input[name=searchOrd]").removeAttr("disabled");
        $("#searchBtn").removeAttr("disabled");
    
        //file Delete
        $("#_fileDel").click(function() {
            $("#attachInvest").val('');
            $(".input_text").val('');
            console.log("fileDel complete.");
        });
    });
    
    //f_multiCombo 함수 호출이 되어야만 multi combo 화면이 안깨짐.
    doGetCombo('/common/selectCodeList.do', '57', '','cmbInvType', 'S' , '');    // Exchange Type Combo Box
    
    function fn_getNewReq(){
        var searchOrd = singleForm.searchOrd.value;

        if(searchOrd == ""){
            Common.alert("Please Key in the Order Number.");
            return false;
        }
        $.ajax({
            
            type : "GET",
            url : getContextPath() + "/sales/order/orderNewRequestSingleChk",
            contentType: "application/json;charset=UTF-8",
            crossDomain: true,
            data: {salesOrdNo : searchOrd},
            dataType: "json",
            success : function (result) {
                if(result.msg == "OK"){
                    var prod = result.stkCode + ' - ' + result.stkDesc;
                    $("#salesOrdId").val(result.salesOrdId);
                    $("#ordId").val(result.salesOrdId);
                    $("#ordNo").html(result.salesOrdNo);
                    $("#salesDt").html(result.salesDt);
                    $("#orderStus").html(result.name);
                    $("#renStus").html(result.stusCodeId);
                    $("#appType").html(result.codeName);
                    $("#prod").html(prod);
                    $("#custName").html(result.name1);
                    $("#nric").html(result.nric);
                    $("#searchOrdDt").show();
                }else if(result.msg == "Err"){
                    Common.alert("* No such sales order found. Only Rental order is allow to request for investigation.");
                    $("#searchOrdDt").hide();
                }
                else if(result.msg == "NO"){
                    Common.alert("Investigation Request for Current Month Was Closed!");
                    $("input[name=searchOrd]").attr('disabled', 'disabled');
                    $("#searchBtn").attr('disabled', 'disabled');
                    $("#searchOrdDt").hide();
                }
                
            },
            error : function (data) {
                Common.removeLoader();
                if(data == null){               //error
                    Common.alert("fail to Load DB");
                }else{                            // No data
                    Common.alert("No order found or this order.");
                }
                
                
            }
        });
    }
    
    function fn_reqInvest(){
        var today = new Date();
        var todayMm = today.getMonth()+1;
        var todayDd = today.getDate();
        var todayYMD = today.getFullYear() +""+ (todayMm<10 ? '0' + todayMm : todayMm) +""+ (todayDd<10 ? '0' + todayDd : todayDd);
        var callDay = document.viewForm.insCallDt.value;
        
        var callDayValue = callDay.substr(6) + callDay.substr(3,2) + callDay.substr(0,2);

        if(document.viewForm.cmbInvType.value == ""){
            Common.alert("<spring:message code='sal.alert.msg.pleaseSelectAnInvestRequest' />");
            return false;
        }
        
        if(callDay == ""){
            Common.alert("<spring:message code='sal.alert.msg.callDateCannotBeEmpty' />!");
            return false;
        }
        if(parseInt(callDayValue) > parseInt(todayYMD)){        // 현재날짜와 비교 callDay > now
            Common.alert("* <spring:message code='sal.alert.msg.calledDateCannotBeFutureDate' />");
            return false;
        }
//      if(document.viewForm.callDt.value == ""){        // rentalScheme와 비교 value > now
//            Common.alert("* Only REGULAR rental order is allow to request for investigation.");
//            return false;
//        }
//      if(document.viewForm.callDt.value == ""){        // rentalScheme와 비교 value > now
//            Common.alert("* This order has ACTIVE investigation request. Request number : IRN0145325 By KRHQ9001 - KRHQ9001 on 2017-08-31 오전 10:37:08.");
//            return false;
//        }
        if(document.viewForm.insVisitDt.value == ""){
            Common.alert("<spring:message code='sal.alert.msg.visitationDateConnotBeEmpty' />");
            return false;
        }
        
        if(document.viewForm.invReqRem.value == ""){
            Common.alert("<spring:message code='sal.alert.msg.pleaseEnterRequestRemark' />!");
            return false;
        }
        
        if(document.viewForm.attachInvest.value != ""){
            var formData = Common.getFormData("viewForm");
            Common.ajaxFile("/sales/order/investFileUpload.do", formData, function(result) {//  첨부파일 정보를 공통 첨부파일 테이블 이용 : 웹 호출 테스트
                
            });
        }
        
        Common.ajax("GET", "/sales/order/orderNewRequestSingleOk", $("#viewForm").serializeJSON(), function(result) {

              console.log("Order Investigation Request successfully saved.");
              console.log("data : " + result);

              $("#invReqId").val(result.invReqId);
              Common.alert("<spring:message code='sal.alert.msg.invRequestSuccessfully' />.",fn_orderNoExist3 );
              
              
//              Common.popupDiv("/sales/order/orderInvestInfoPop.do", $("#viewForm").serializeJSON());
          },  function(jqXHR, textStatus, errorThrown) {
              try {
                  console.log("status : " + jqXHR.status);
                  console.log("code : " + jqXHR.responseJSON.code);
                  console.log("message : " + jqXHR.responseJSON.message);
                  console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);

                  Common.alert("Failed to save order.<br />"+"Error message : " + jqXHR.responseJSON.message + "</b>");
              }
              catch (e) {
                  console.log(e);
//                alert("Saving data prepration failed.");
              }
              alert("Fail : " + jqXHR.responseJSON.message);
        });
    }
    
    function setInputFile2(){//인풋파일 세팅하기
        $(".auto_file2").append("<label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label><span class='label_text'><a id='_fileDel'>Delete</a></span>");
    }
    
    function fn_goLedger1(){
        Common.popupWin('viewForm', "/sales/order/orderLedgerViewPop.do", option);
    }
</script>

<div id="popup_wrap" class="popup_wrap size_mid"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.page.title.orderInvestigationRequest" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="singleClose"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form id="singleForm" name="singleForm" method="GET">
    <input type="hidden" id="salesOrdNo" name="salesOrdNo">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.title.text.ordNop" /></th>
    <td><input type="text" id="searchOrd" name="searchOrd" disabled="disabled" title="" placeholder="" class="" />
        <p class="btn_sky"><a href="#" id="searchBtn" onClick="fn_getNewReq()" disabled="disabled"><spring:message code="sal.btn.confirm" /></a></p>
        <p class="btn_sky"><a href="#" onClick="fn_orderNoExist2()"><spring:message code="sal.btn.clear" /></a></p>
    </td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<div id="searchOrdDt" style="display:none;">
<aside class="title_line"><!-- title_line start -->
<h3><spring:message code="sal.title.text.particInfo" /></h3>
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#"  onclick="javascript : fn_goLedger1()"><spring:message code="sal.btn.viewOrderLedger1" /></a></p></li>
</ul>
</aside><!-- title_line end -->

<form id="viewForm" name="viewForm" enctype="multipart/form-data" action="#" method="post">
<input type="hidden" id="invReqId" name="invReqId">
<input type="hidden" id="salesOrdId" name="salesOrdId">
<input type="hidden" id="ordId" name="ordId">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.ordNo" /></th>
    <td><span id="ordNo"></span></td>
    <th scope="row"><spring:message code="sal.text.ordDate" /></th>
    <td><span id="salesDt"></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.ordStus" /></th>
    <td><span id="orderStus"></span></td>
    <th scope="row"><spring:message code="sal.text.rentalStatus" /></th>
    <td><span id="renStus"></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.appType" /></th>
    <td><span id="appType">${codeName}</span></td>
    <th scope="row"><spring:message code="sal.title.text.product" /></th>
    <td><span id="prod">${stkCode} - ${stkDesc}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.custName" /></th>
    <td><span id="custName">${name1}</span></td>
    <th scope="row"><spring:message code="sal.text.nric" /></th>
    <td><span id="nric">${nric}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.investigateType" /></th>
    <td colspan="3">
        <select id="cmbInvType" name="cmbInvType">
        </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.calledDate" /></th>
    <td colspan="3"><input type="text" id="insCallDt" name="insCallDt" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.visitationDate" /></th>
    <td colspan="3"><input type="text" id="insVisitDt" name="insVisitDt" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.attachment" /></th>
    <td colspan="3">
    <div class="auto_file2"><!-- auto_file start -->
    <input type="file" id="attachInvest" name="attachInvest" title="file add" />
    </div><!-- auto_file end -->
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.remark" /></th>
    <td colspan="3"><textarea cols="20" rows="5" id="invReqRem" name="invReqRem"></textarea></td>
</tr>
</tbody>
</table><!-- table end -->
</form>
<ul class="center_btns">
    <li><p class="btn_blue"><a href="#" onClick="fn_reqInvest()"><spring:message code="sal.btn.requestInvestigate" /></a></p></li>
</ul>
</div>

</section><!-- container end -->

</div><!-- popup_wrap end -->