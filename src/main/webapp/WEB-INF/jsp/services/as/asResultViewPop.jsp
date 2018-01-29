<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<script type="text/javaScript">


$(document).ready(function(){
	
	createAUIGrid();

	fn_getASOrderInfo();
    fn_getASEvntsInfo();
    fn_getCallLog();
});

var  regGridID;

function createAUIGrid() {
    
    var columnLayout = [
                        {dataField : "callRem",     headerText  : "Remark" ,editable       : false  } ,
                        { dataField : "c2", headerText  : "KeyBy",  width  : 80 , editable       : false},
                        { dataField : "callCrtDt", headerText  : "KeyAt ",  width  : 120  ,dataType : "date", formatString : "dd/mm/yyyy" }
                     
   ];   
   
    
    var gridPros = { usePaging : true,  pageRowCount: 20, editable: false, fixedColumnCount : 1, selectionMode : "singleRow",  showRowNumColumn : true, showStateColumn : false};  
    regGridID= GridCommon.createAUIGrid("reg_grid_wrap", columnLayout  ,"" ,gridPros);
}
   

function fn_getASOrderInfo(){
        Common.ajax("GET", "/services/as/getASOrderInfo.do", $("#resultASForm").serialize(), function(result) {
            console.log("fn_getASOrderInfo.");
            
            console.log(result);
            
            $("#txtASNo").text($("#AS_NO").val());
            $("#txtOrderNo").text(result[0].ordNo);
            $("#txtAppType").text(result[0].appTypeCode);
            $("#txtCustName").text(result[0].custName);
            $("#txtCustIC").text(result[0].custNric);
            $("#txtContactPerson").text(result[0].instCntName);
            
            $("#txtTelMobile").text(result[0].instCntTelM);
            $("#txtTelResidence").text(result[0].instCntTelR);
            $("#txtTelOffice").text(result[0].instCntTelO);
            //$("#txtInstallAddress").text(result[0].instCntName);
            $("#txtInstallAddress").text(result[0].instAddrDtl);
            
            $("#txtProductCode").text(result[0].stockCode);
            $("#txtProductName").text(result[0].stockDesc);
            $("#txtSirimNo").text(result[0].lastInstallSirimNo);
            $("#txtSerialNo").text(result[0].lastInstallSerialNo);
            
            $("#txtCategory").text(result[0].c2);
            $("#txtInstallNo").text(result[0].lastInstallNo);
            $("#txtInstallDate").text(result[0].c1);
            $("#txtInstallBy").text(result[0].lastInstallCtCode);
            $("#txtInstruction").text(result[0].instct);
            $("#txtMembership").text(result[0].c5);
            $("#txtExpiredDate").text(result[0].c6);
            
            //$("#txtASKeyBy").text(result[0].userFullName);
            
        });
}


function fn_getASEvntsInfo(){
    Common.ajax("GET", "/services/as/getASEvntsInfo.do", $("#resultASForm").serialize(), function(result) {
        console.log("getASEvntsInfo.");
        console.log( result);
      
        $("#txtASStatus").text(result[0].code);
        $("#txtRequestDate").text(result[0].asReqstDt);
        $("#txtRequestTime").text(result[0].asReqstTm);
        //$("#txtMalfunctionCode").text('에러코드 정의값');
        //$("#txtMalfunctionReason").text('에러코드 desc');
        

        $("#txtMalfunctionCode").text(result[0].asMalfuncId);
        $("#txtMalfunctionReason").text(result[0].asMalfuncResnId);
        
        /* $("#txtDSCCode").text(result[0].c7 +"-" +result[0].c8 ); */
        $("#txtInchargeCT").text(result[0].c10 +"-" +result[0].c11 );
        
        $("#txtRequestor").text(result[0].c3);
        $("#txtASKeyBy").text(result[0].c1);
        $("#txtRequestorContact").text(result[0].asRemReqsterCntc); 
        $("#txtASKeyAt").text(result[0].asCrtDt);
        $("#prevServiceArea").text(result[0].prevSvcArea);
        $("#nextServiceArea").text(result[0].nextSvcArea);
        $("#distance").text(result[0].distance)
    });
}
function fn_getCallLog(){
    Common.ajax("GET", "/services/as/getCallLog", $("#resultASForm").serialize(), function(result) {
        console.log("fn_getCallLog.");
        console.log( result);
        AUIGrid.setGridData(regGridID, result);
    });
}




</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->


<form id="resultASForm" method="post">
    <div  style="display:none">
        <input type="text" name="AS_ID"   id="AS_ID"  value="${AS_ID}"/>
        <input type="text" name="ORD_ID"   id="ORD_ID"  value="${ORD_ID}"/>
        <input type="text" name="ORD_NO"   id="ORD_NO"  value="${ORD_NO}"/>
        <input type="text" name="AS_NO"   id="AS_NO"  value="${AS_NO}"/>
    </div>
</form>


<header class="pop_header"><!-- pop_header start -->
<h1>AS Application - View</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
	<li><a href="#" class="on">Basic</a></li>
	<li><a href="#">Product Info</a></li>
	<li><a href="#">AS Event</a></li>
</ul>



<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">AS No</th>
    <td>
    <span id="txtASNo">AS No</span>
    </td>
    <th scope="row">Order No</th>
    <td>
        <span id="txtOrderNo">text</span>
    </td>
    <th scope="row">Application Type</th>
    <td>   
        <span id="txtAppType">text</span>
    </td>
</tr>
<tr>
    <th scope="row">Customer Name</th>
    <td colspan="3">   <span id="txtCustName">text</span> </td>
    <th scope="row">NRIC/Company Np</th>
    <td>   <span id="txtCustIC">text</span> </td>
</tr>
<tr>
    <th scope="row">Contact Person</th>
    <td colspan="5">   <span id="txtContactPerson">text</span>   </td>
</tr>
<tr>
    <th scope="row">Tel (Mobile)</th>
    <td>   <span id="txtTelMobile">text</span></td>
    <th scope="row">Tel (Residence)</th>
    <td>   <span id="txtTelResidence">text</span> </td>
    <th scope="row">Tel (Office)</th>
    <td>   <span id="txtTelOffice">text</span>  </td>
</tr>
<tr>
    <th scope="row">Installation Address</th>
    <td colspan="5">   <span id="txtInstallAddress">text</span> </td>
</tr>
<tr>
    <th scope="row">Requestor</th>
    <td colspan="3">   <span id="txtRequestor">text</span>  </td>
    <th scope="row">AS Key By</th>
    <td> <span id="txtASKeyBy">text</span> </td>
</tr>
<tr>
    <th scope="row">Requestor Contact</th>
    <td colspan="3">   <span id="txtRequestorContact"></span>  </td>
    <th scope="row">AS Key At</th>
    <td>   <span id="txtASKeyAt">text</span>  </td>
</tr>
<tr>
    <th scope="row">Prev Service Area</th>
    <td>   <span id="prevServiceArea"></span>  </td>
    <th scope="row">Next Service Area</th>
    <td>   <span id="nextServiceArea"></span>  </td>
    <th scope="row">Distance</th>
    <td>   <span id="distance"></span>  </td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->


<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Product Code</th>
    <td>
         <span id="txtProductCode"></span> 
    </td>
    <th scope="row">Product Name</th>
    <td colspan="3">   <span id="txtProductName"></span>   </td>
</tr>
<tr>
    <th scope="row">Sirim No</th>
    <td>   <span id="txtSirimNo"></span> </td>
    <th scope="row">Serial No</th>
    <td>   <span id="txtSerialNo"></span>    </td>
    <th scope="row">Category</th>
    <td>   <span id="txtCategory"></span> </td>
</tr>
<tr>
    <th scope="row">Install No</th>
    <td> <span id="txtInstallNo"></span>   </td>
    <th scope="row">Install Date</th>
    <td><span id="txtInstallDate"></span>  </td>
    <th scope="row">Install By</th>
    <td><span id="txtInstallBy"></span>  </td>
</tr>
<tr>
    <th scope="row">Instruction</th>
    <td colspan="5"><span id="txtInstruction"></span>  </td>
</tr>
<tr>
    <th scope="row">Membership</th>
    <td colspan="3"><span id="txtMembership"></span>  </td>
    <th scope="row">Expired Date</th>
    <td><span id="txtExpiredDate"></span> </td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->


<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">AS Status</th>
    <td>
    <span id='txtASStatus'></span>
    </td>
    <th scope="row">Request Date</th>
    <td>    <span id='txtRequestDate'></span> </td>
    <th scope="row">Request Time</th>
    <td><span id='txtRequestTime'><c:out value="${AsEventInfo.reqTm}"/></span> </td>
</tr>
<tr>
    <th scope="row">Malfunction Code</th>
    <td>
      <span id='txtMalfunctionCode'><c:out value="${AsEventInfo.malfuCode}"/></span> 
    </td>
    <th scope="row">Malfunction Reason</th>
    <td colspan="3"><span id='txtMalfunctionReason'><c:out value="${AsEventInfo.malfuReason}"/></span>  </td>
</tr>
<tr>
    <th scope="row">DSC Code</th>
    <td>
     <span id='txtDSCCode'><c:out value="${AsEventInfo.dsc}"/></span> 
    </td>
    <th scope="row">Incharge Technician</th>
    <td colspan="3"><span id='txtInchargeCT'></span> </td>
</tr>
</tbody>
</table><!-- table end -->

<article class="grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

</section><!-- tap_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h2>AS Call-Log Transaction</h2>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
      <div id="reg_grid_wrap" style="width:100%; height:300px; margin:0 auto;"></div>
      </article><!-- grid_wrap end -->

</section><!-- pop_body end -->
