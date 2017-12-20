<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

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
        fn_orderInvestigationListAjax();
        Common.popupDiv("/sales/order/orderInvestInfoPop.do", $("#popForm").serializeJSON(), null, true, 'dtPop');
    }
    
    $(document).ready(function(){
        
        $("input[name=searchOrd]").removeAttr("disabled");
        $("#searchBtn").removeAttr("disabled");
    
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
            Common.alert("Please select an Investigation Request Type.");
            return false;
        }
        if(callDay == ""){
            Common.alert("Call Date Cannot be Empty!");
            return false;
        }
        if(parseInt(callDayValue) > parseInt(todayYMD)){        // 현재날짜와 비교 callDay > now
            Common.alert("* Called Date cannot be future date.");
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
            Common.alert("Visitation Date Cannot be Empty!");
            return false;
        }
        if(document.viewForm.invReqRem.value == ""){
            Common.alert("Please enter request remark!!");
            return false;
        }
        
        Common.ajax("GET", "/sales/order/orderNewRequestSingleOk", $("#viewForm").serializeJSON(), function(result) {

              console.log("Order Investigation Request successfully saved.");
              console.log("data : " + result);

              $("#invReqId").val(result.invReqId);
              Common.alert("Order Investigation Request successfully saved.",fn_orderNoExist3 );
              
              
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
    
//    function fn_viewSingle(salesOrdNoVal){
//      document.searchForm.salesOrdNo.value = salesOrdNoVal;
//      document.searchForm.action = '/sales/order/orderNewRequestSingleView';
//        document.searchForm.submit();
//    }
</script>

<div id="popup_wrap" class="popup_wrap size_mid"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Order Investigation Request</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
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
    <th scope="row">Order No.</th>
    <td><input type="text" id="searchOrd" name="searchOrd" disabled="disabled" title="" placeholder="" class="" />
        <p class="btn_sky"><a href="#" id="searchBtn" onClick="fn_getNewReq()" disabled="disabled">Confirm</a></p>
        <p class="btn_sky"><a href="#" onClick="fn_orderNoExist2()">Clear</a></p>
    </td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<div id="searchOrdDt" style="display:none;">
<aside class="title_line"><!-- title_line start -->
<h3>Particular Information</h3>
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#">View Rent Ledger</a></p></li>
</ul>
</aside><!-- title_line end -->

<form id="viewForm" name="viewForm">
<input type="hidden" id="invReqId" name="invReqId">
<input type="hidden" id="salesOrdId" name="salesOrdId">
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
    <th scope="row">Order No.</th>
    <td><span id="ordNo"></span></td>
    <th scope="row">Order Date</th>
    <td><span id="salesDt"></span></td>
</tr>
<tr>
    <th scope="row">Order Status</th>
    <td><span id="orderStus"></span></td>
    <th scope="row">Rental Status</th>
    <td><span id="renStus"></span></td>
</tr>
<tr>
    <th scope="row">Application Type</th>
    <td><span id="appType">${codeName}</span></td>
    <th scope="row">Product</th>
    <td><span id="prod">${stkCode} - ${stkDesc}</span></td>
</tr>
<tr>
    <th scope="row">Customer Name</th>
    <td><span id="custName">${name1}</span></td>
    <th scope="row">NRIC</th>
    <td><span id="nric">${nric}</span></td>
</tr>
<tr>
    <th scope="row">Investigate Type</th>
    <td colspan="3">
        <select id="cmbInvType" name="cmbInvType">
        </select>
    </td>
</tr>
<tr>
    <th scope="row">Called Date</th>
    <td colspan="3"><input type="text" id="insCallDt" name="insCallDt" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></td>
</tr>
<tr>
    <th scope="row">Visitation Date</th>
    <td colspan="3"><input type="text" id="insVisitDt" name="insVisitDt" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></td>
</tr>
<tr>
    <th scope="row">Attachement</th>
    <td colspan="3">
    <div class="auto_file"><!-- auto_file start -->
    <input type="file" id="attachInvest" name="attachInvest" title="file add" />
    </div><!-- auto_file end -->
    </td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="3"><textarea cols="20" rows="5" id="invReqRem" name="invReqRem"></textarea></td>
</tr>
</tbody>
</table><!-- table end -->
</form>
<ul class="center_btns">
    <li><p class="btn_blue"><a href="#" onClick="fn_reqInvest()">Request Investigate</a></p></li>
</ul>
</div>

</section><!-- container end -->

</div><!-- popup_wrap end -->