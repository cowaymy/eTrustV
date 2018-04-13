<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<script type="text/javaScript">


var  regGridID;

$(document).ready(function(){

    createAUIGrid();

    fn_getASOrderInfo();
    fn_getASEvntsInfo();
    fn_getASHistoryInfo();
    fn_selectASDataInfo();
});



function createAUIGrid() {

    var columnLayout = [
                        {dataField : "asNo",     headerText  : "Type" ,editable       : false  } ,
                        { dataField : "c2", headerText  : "ASR No",  width  : 80 , editable       : false ,dataType : "date", formatString : "dd/mm/yyyy"},
                        { dataField : "code", headerText  : "Status ",  width  : 80 },
                        //{ dataField : "asReqstDt",       headerText  : "Request Date",  width  : 100 ,editable       : false  ,dataType : "date", formatString : "dd/mm/yyyy"},
                        //{ dataField : "asSetlDt",       headerText  : "Settle Date",  width  : 100 ,editable       : false  ,dataType : "date", formatString : "dd/mm/yyyy"},
                        { dataField : "asReqstDt",       headerText  : "Request Date",  width  : 100 ,editable       : false  },
                        { dataField : "asSetlDt",       headerText  : "Settle Date",  width  : 100 ,editable       : false  },
                        { dataField : "c3",     headerText  : "Error Code",  width          :150,    editable       : false },
                        { dataField : "c4",     headerText  : "Error Desc",  width          :150,    editable       : false },
                        { dataField : "c5",     headerText  : "CT Code",  width          :150,    editable       : false },
                        { dataField : "c6",     headerText  : "Solution",  width          :150,    editable       : false},
                        { dataField : "c7",     headerText  : "Amount",  width          :150,    dataType:"numeric", formatString : "#,##0.00" ,editable       : false  }
   ];


    var gridPros = { usePaging : true,  pageRowCount: 20, editable: true, fixedColumnCount : 1, selectionMode : "singleRow",  showRowNumColumn : true};
    regGridID= GridCommon.createAUIGrid("reg_grid_wrap", columnLayout  ,"" ,gridPros);
}




var aSOrderInfo;
function fn_getASOrderInfo(){
        Common.ajax("GET", "/services/as/getASOrderInfo.do", $("#resultASForm").serialize(), function(result) {
            console.log("fn_getASOrderInfo.");

            console.log(result);

            aSOrderInfo = result[0];


            $("#txtASNo").text($("#AS_NO").val());
            $("#txtOrderNo").text(result[0].ordNo);
            $("#txtAppType").text(result[0].appTypeCode);
            $("#txtCustName").text(result[0].custName);
            $("#txtCustIC").text(result[0].custNric);
            $("#txtContactPerson").text(result[0].instCntName);

            $("#txtTelMobile").text(result[0].instCntTelM);
            $("#txtTelResidence").text(result[0].instCntTelR);
            $("#txtTelOffice").text(result[0].instCntTelO);
            $("#txtInstallAddress").text(result[0].instCntName);

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

            var prdctCd=$("#txtProductCode").text();
            doGetCombo('/services/as/getASFilterInfo.do?prdctCd='+prdctCd, '', '','ddlFilterCode', 'S' , '');

        });
}


function fn_getASEvntsInfo(){
    Common.ajax("GET", "/services/as/getASEvntsInfo.do", $("#resultASForm").serialize(), function(result) {
        console.log("getASEvntsInfo.");
        console.log( result);

        $("#txtASStatus").text(result[0].code);
        $("#txtRequestDate").text(result[0].asReqstDt);
        $("#txtRequestTime").text(result[0].asReqstTm);

        $("#txtMalfunctionCode").text(result[0].asMalfuncId);
        $("#txtMalfunctionReason").text(result[0].asMalfuncResnId);

        //$("#txtMalfunctionCode").text('에러코드 정의값');
        //$("#txtMalfunctionReason").text('에러코드 desc');

        $("#txtDSCCode").text(result[0].c7 +"-" +result[0].c8 );
        $("#txtInchargeCT").text(result[0].c10 +"-" +result[0].c11 );

        $("#txtRequestor").text(result[0].c3);
        $("#txtASKeyBy").text(result[0].c1);
        $("#txtRequestorContact").text(result[0].asRemReqsterCntc);
        $("#txtASKeyAt").text(result[0].asCrtDt);


    });
}


function fn_getASHistoryInfo(){

    Common.ajax("GET", "/services/as/getASHistoryInfo.do", $("#resultASForm").serialize(), function(result) {
        console.log("fn_getASHistoryInfo.");
        console.log( result);
        AUIGrid.setGridData(regGridID, result);
    });
}




var asDataInfo={};

function fn_selectASDataInfo(){

    Common.ajax("GET", "/services/as/selectASDataInfo", $("#resultASForm").serialize(), function(result) {
        console.log("selectASDataInfo.");
        console.log( result);
        asDataInfo = result;
    });
}




function setPopData(){

    var options ={
            AS_ID : '${AS_ID}',
            AS_SO_ID:'${ORD_ID}',
            AS_RESULT_ID: '${AS_RESULT_ID}',
            AS_RESULT_NO:'${AS_RESULT_NO}',
            MOD:   '${MOD}',
            ORD_NO :'${ORD_NO}'
   };

   fn_setASDataInit(options);
   fn_asResult_editPageContral("RESULTEDIT");

   if( '${MOD}' =="RESULTVIEW"){
       $("#btnSaveDiv").attr("style","display:none");

       $("#btnSaveDiv").attr("style","display:none");
       $("#addDiv").attr("style","display:none");

       $('#dpSettleDate').attr("disabled", true);
       $('#ddlFailReason').attr("disabled", true);
       $('#tpSettleTime').attr("disabled", true);
       $('#ddlDSCCode').attr("disabled", true);

       $('#ddlErrorCode').attr("disabled", true);
       $('#ddlCTCode').attr("disabled", true);
       $('#ddlErrorDesc').attr("disabled", true);
       $('#ddlWarehouse').attr("disabled", true);
       $('#txtRemark').attr("disabled", true);
       $("#iscommission").attr("disabled", true);
       $("#ddlFilterCode").attr("disabled", true);
       $("#ddlFilterQty").attr("disabled", true);
       $("#ddlFilterPayType").attr("disabled", true);
       $("#ddlFilterExchangeCode").attr("disabled", true);
       $("#txtFilterRemark").attr("disabled", true);
       $("#txtLabourCharge").attr("disabled", true);
       $("#txtFilterCharge").attr("disabled", true);

       $('#def_type').attr("disabled", true) ;
       $('#def_code').attr("disabled", true);
       $('#def_part').attr("disabled", true);
       $('#def_def').attr("disabled", true);

       $('#def_type_text').attr("disabled", true);
       $('#def_code_text').attr("disabled", true);
       $('#def_part_text').attr("disabled", true);
       $('#def_def_text').attr("disabled", true);

       $('#solut_code').attr("disabled", true);
       $('#solut_code_text').attr("disabled", true);


   }
};

</script>



<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<section id="content"><!-- content start -->


<form id="resultASForm" method="post">
    <div  style="display:none">
        <input type="text" name="ORD_ID"  id="ORD_ID" value="${ORD_ID}"/>
        <input type="text" name="ORD_NO"   id="ORD_NO"  value="${ORD_NO}"/>
        <input type="text" name="AS_NO"   id="AS_NO"  value="${AS_NO}"/>
        <input type="text" name="AS_ID"   id="AS_ID"  value="${AS_ID}"/>
        <input type="text" name="MOD"   id="MOD"  value="${MOD}"/>
        <input type="text" name="AS_RESULT_NO"   id="AS_RESULT_NO"  value="${AS_RESULT_NO}"/>
        <input type="text" name="AS_RESULT_ID"   id="AS_RESULT_ID"  value="${AS_RESULT_ID}"/>

    </div>
</form>

<header class="pop_header"><!-- pop_header start -->
<h1>    <spain id='title_spain'>
    <c:if test="${MOD eq  'RESULTVIEW' }">   View AS Result Entry </c:if>
    <c:if test="${MOD eq  'RESULTEDIT' }"> Edit  AS Result Entry </c:if>
</spain>  </h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->
<section class="pop_body"><!-- pop_body start -->
<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on">Basic Info</a></li>
    <li><a href="#">Product Info</a></li>
    <li><a href="#">AS Events</a></li>
    <li><a href="#" onclick=" javascirpt:AUIGrid.resize(regGridID, 950,300);  ">After Service</a></li>
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
    <span id="txtASNo"></span>
    </td>
    <th scope="row">Order No</th>
    <td>
        <span id="txtOrderNo"></span>
    </td>
    <th scope="row">Application Type</th>
    <td>
        <span id="txtAppType"></span>
    </td>
</tr>
<tr>
    <th scope="row">Customer Name</th>
    <td colspan="3">   <span id="txtCustName"></span> </td>
    <th scope="row">NRIC/Company Np</th>
    <td>   <span id="txtCustIC"></span> </td>
</tr>
<tr>
    <th scope="row">Contact Person</th>
    <td colspan="5">   <span id="txtContactPerson"></span>   </td>
</tr>
<tr>
    <th scope="row">Tel (Mobile)</th>
    <td>   <span id="txtTelMobile"></span></td>
    <th scope="row">Tel (Residence)</th>
    <td>   <span id="txtTelResidence"></span> </td>
    <th scope="row">Tel (Office)</th>
    <td>   <span id="txtTelOffice"></span>  </td>
</tr>
<tr>
    <th scope="row">Installation Address</th>
    <td colspan="5">   <span id="txtInstallAddress"></span> </td>
</tr>
<tr>
    <th scope="row">Requestor</th>
    <td colspan="3">   <span id="txtRequestor"></span>  </td>
    <th scope="row">AS Key By</th>
    <td>
    </td>
</tr>
<tr>
    <th scope="row">Requestor Contact</th>
    <td colspan="3">   <span id="txtRequestorContact"></span>  </td>
    <th scope="row">AS Key At</th>
    <td>   <span id="txtASKeyAt"></span>  </td>
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
    <td><span id='txtRequestTime'></span> </td>
</tr>
<tr>
    <th scope="row">Malfunction Code</th>
    <td>
      <span id='txtMalfunctionCode'></span>
    </td>
    <th scope="row">Malfunction Reason</th>
    <td colspan="3"><span id='txtMalfunctionReason'></span>  </td>
</tr>
<tr>
    <th scope="row">DSC Code</th>
    <td>
     <span id='txtDSCCode'></span>
    </td>
    <th scope="row">Incharge Technician</th>
    <td colspan="3"><span id='txtInchargeCT'></span> </td>
</tr>
</tbody>
</table><!-- table end -->

<article class="grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
      <div id="reg_grid_wrap" style="width:100%; height:300px; margin:0 auto;"></div>

</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

</section><!-- tap_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h3 class="red_text">Fill the result at below :</h3>
</aside><!-- title_line end -->



<!-- asResultInfo info tab  start...-->
<jsp:include page ='${pageContext.request.contextPath}/services/as/asResultInfoEdit.do'/>
<!-- asResultInfo info tab  end...-->


<script>




</script>


</article><!-- acodi_wrap end -->
<ul class="center_btns mt20" id='btnSaveDiv'>
    <li><p class="btn_blue2 big"><a href="#"   onclick="fn_doSave()">Save</a></p></li>
    <li><p class="btn_blue2 big"><a href="#"    onClick="fn_doClear()" >Clear</a></p></li>
</ul>

</section><!-- content end -->
</section><!-- content end -->
</div><!-- popup_wrap end -->



