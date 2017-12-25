<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
$(document).ready(function () {
$("#close_btn2").click(fn_closePop2);
    
    $("#rRefAmt").keydown(function (event) { 
        
        var code = window.event.keyCode;
        
        if ((code > 34 && code < 41) || (code > 47 && code < 58) || (code > 95 && code < 106) ||code==110 ||code==190 ||code == 8 || code == 9 || code == 13 || code == 46)
        {
         window.event.returnValue = true;
         return;
        }
        window.event.returnValue = false;

        return false;
   });
   
   $("#rRefAmt").click(function () { 
       var str = $("#rRefAmt").val().replace(/,/gi, "");
       $("#rRefAmt").val(str);      
  });
   
   $("#rRefAmt").blur(function () { 
       var str = $("#rRefAmt").val().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
       $("#rRefAmt").val(str);  
  });
   
    $("#rRefAmt").change(function(){
       var str =""+ Math.floor($("#rRefAmt").val() * 100)/100;
              
       var str2 = str.split(".");
      
       if(str2.length == 1){           
           str2[1] = "00";
       }
       
       if(str2[0].length > 11){
           Common.alert("<spring:message code='budget.msg.inputAmount' />");
              str = $("#rAmt").val().replace(/,/gi, "");
       }else{               
           str = str2[0].substr(0, 11)+"."+str2[1] + "00".substring(str2[1].length, 2);   
       }
       
       if(Number($("#rRefAmt").val().replace(/,/gi, "")) > Number($("#rAmt").val().replace(/,/gi, ""))) {
           Common.alert('Refund Amount can not be greater than Amount.');
           str = $("#rAmt").val().replace(/,/gi, "");
       }
       
       str = str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
       
       $("#rRefAmt").val(str);
       
   }); 
});

function fn_closePop2() {
    $("#refundInfoKeyInPop").remove();
    //$("#ref_popup_wrap").hide();
}

function fn_setAccNo() {
    CommonCombo.make("rAccNo", "/payment/selectAccNoList.do", {payMode:$("#rRefMode").val()}, "", {
        id: "codeId",
        name: "codeName",
        type:"S"
    });
}

function fn_rClear() {
    $("#rRefMode").val("106");
    $("#rRefAmt").val($("#rAmt").val());
    $("#rCcNo").val("");
    $("#rChqNo").val("");
    $("#rCcHolderName").val("");
}

function fn_updateGridData() {
    console.log("fn_updateGridData Action");
    AUIGrid.setCellValue(confirmGridID, selectedRowIndex, "refAmt", $("#rRefAmt").val().replace(/,/gi, ""));
    AUIGrid.setCellValue(confirmGridID, selectedRowIndex, "refModeCode", $("#rRefMode option:selected").val());
    AUIGrid.setCellValue(confirmGridID, selectedRowIndex, "refModeName", $("#rRefMode option:selected").text());
    AUIGrid.setCellValue(confirmGridID, selectedRowIndex, "bankAccCode", $("#rAccNo option:selected").val());
    AUIGrid.setCellValue(confirmGridID, selectedRowIndex, "bankAccName", $("#rAccNo option:selected").text());
    AUIGrid.setCellValue(confirmGridID, selectedRowIndex, "cardNo", $("#rCcNo").val());
    AUIGrid.setCellValue(confirmGridID, selectedRowIndex, "cardHolder", $("#rCcHolderName").val());
    AUIGrid.setCellValue(confirmGridID, selectedRowIndex, "chqNo", $("#rChqNo").val());
    
    fn_rClear();
    fn_closePop2();
    
    selectedRowIndex = null;
}
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Update Refund Data</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="close_btn2"><spring:message code='sys.btn.close'/></a></p></li>
</ul>

</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->

<form action="#" id="form_refundInfo">

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
    <th scope="row">Sales Order No.</th>
    <td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="rSalesOrdNo"/></td>
    <th scope="row">OR No.</th>
    <td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="rOrNo"/></td>
</tr>
<tr>
    <th scope="row">Customer Name</th>
    <td colspan="3"><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="rCustName"/></td>
</tr>
<tr>
    <th scope="row">Amount</th>
    <td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="rAmt"/></td>
    <th scope="row"></th>
    <td></td>
</tr>
<tr>
    <th scope="row">Refund Mode</th>
    <td>
    <select class="" id="rRefMode" onchange="javascript:fn_setAccNo()"></select>
    </td>
    <th scope="row"></th>
    <td></td>
</tr>
<tr>
    <th scope="row">Bank Account</th>
    <td>
    <select class="" id="rAccNo"></select>
    </td>
    <th scope="row"></th>
    <td></td>
</tr>
<tr>
    <th scope="row">Refund Amount</th>
    <td><input type="text" title="" placeholder="" class="" id="rRefAmt"/></td>
    <th scope="row"></th>
    <td></td>
</tr>
<tr>
    <th scope="row">Credit Card No.</th>
    <td><input type="text" title="" placeholder="" class="" id="rCcNo" autocomplete="off"/></td>
    <th scope="row">Cheque No.</th>
    <td><input type="text" title="" placeholder="" class="" id="rChqNo" autocomplete="off"/></td>
</tr>
<tr>
    <th scope="row">Credit Card Holder Name</th>
    <td><input type="text" title="" placeholder="" class="" id="rCcHolderName"/></td>
    <th scope="row"></th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->
</form>

</section><!-- search_table end -->

<ul class="center_btns" id="confirm_btn_area">
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_updateGridData()" ><spring:message code='sys.btn.save'/></a></p></li>
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_rClear()"><spring:message code='sys.btn.clear'/></a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
