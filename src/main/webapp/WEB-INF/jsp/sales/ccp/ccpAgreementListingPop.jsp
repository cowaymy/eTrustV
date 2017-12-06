<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

var date = new Date().getDate();
if(date.toString().length == 1){
    date = "0" + date;
} 
$("#dpDateFrom").val(date+"/"+(new Date().getMonth()+1)+"/"+new Date().getFullYear());
$("#dpDateTo").val(date+"/"+(new Date().getMonth()+1)+"/"+new Date().getFullYear());

/* 멀티셀렉트 플러그인 start */
$('.multy_select').change(function() {
   //console.log($(this).val());
})
.multipleSelect({
   width: '100%'
});


$.fn.clearForm = function() {
    return this.each(function() {
        var type = this.type, tag = this.tagName.toLowerCase();
        if (tag === 'form'){
            return $(':input',this).clearForm();
        }
        if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea'){
            this.value = '';
        }else if (type === 'checkbox' || type === 'radio'){
            this.checked = false;
        }else if (tag === 'select'){
            this.selectedIndex = 0;
        }
        $("#dpDateFrom").val(date+"/"+(new Date().getMonth()+1)+"/"+new Date().getFullYear());
        $("#dpDateTo").val(date+"/"+(new Date().getMonth()+1)+"/"+new Date().getFullYear());
    });
};


function fn_report() {

	$("#V_WHERESQL").val("");
	$("#V_ORDERBYSQL").val("");
	var txtOrderNo1 = $("#txtOrderNo1").val().trim();
	var txtOrderNo2 = $("#txtOrderNo2").val().trim();
	var whereSQL = "";
	var orderSQL = "";
	
	if(!(txtOrderNo1 == null || txtOrderNo1.length == 0) && !(txtOrderNo2 == null || txtOrderNo2.length == 0)){
		whereSQL += " AND (OrM.SALES_ORD_NO BETWEEN '"+txtOrderNo1+"' AND '"+txtOrderNo2+"')";
	}else{
		if(!(txtOrderNo1 == null || txtOrderNo1.length == 0) && (txtOrderNo2 == null || txtOrderNo2.length == 0)){
			whereSQL += " AND OrM.SALES_ORD_NO >= '"+txtOrderNo1+"'";
		}else if((txtOrderNo1 == null || txtOrderNo1.length == 0) && !(txtOrderNo2 == null || txtOrderNo2.length == 0)){
			whereSQL += " AND OrM.SALES_ORD_NO <= '"+txtOrderNo2+"'";
		}
	}
	
	if($("#cmbAgrType option:selected").index() > 0){
		whereSQL += " AND ArgM.GOV_AG_TYPE_ID = '"+$("#cmbAgrType option:selected").val()+"'";
	}
	if($("#cmbProgress option:selected").index() > 0){
		whereSQL += " AND ArgM.GOV_AG_PRGRS_ID = '"+$("#cmbProgress option:selected").val()+"'";
	}
    if($("#cmbCCPStatus option:selected").index() > 0){
    	whereSQL += " AND CCP.CCP_STUS_ID = '"+$("#cmbCCPStatus option:selected").val()+"'";
    }
   
    if(!($("#dpDateFrom").val() == null || $("#dpDateFrom").val().length == 0) && !($("#dpDateTo").val() == null || $("#dpDateTo").val().length == 0)){
    	whereSQL += " AND ArgM.GOV_AG_CRT_DT BETWEEN TO_DATE('"+$("#dpDateFrom").val()+"', 'dd/MM/yy') AND TO_DATE('"+$("#dpDateTo").val()+"', 'dd/MM/yy')";
    }
    if(!($("#dtAgmStartFr").val() == null || $("#dtAgmStartFr").val().length == 0) && !($("#dtAgmStartTo").val() == null || $("#dtAgmStartTo").val().length == 0)){
    	whereSQL += " AND ArgM.GOV_AG_START_DT BETWEEN TO_DATE('"+$("#dtAgmStartFr").val()+"', 'dd/MM/yy') AND TO_DATE('"+$("#dtAgmStartTo").val()+"', 'dd/MM/yy')";
    }
    if(!($("#dtAgmExpiryFr").val() == null || $("#dtAgmExpiryFr").val().length == 0) && !($("#dtAgmExpiryTo").val() == null || $("#dtAgmExpiryTo").val().length == 0)){
    	whereSQL += " AND ArgM.GOV_AG_END_DT BETWEEN TO_DATE('"+$("#dtAgmExpiryFr").val()+"', 'dd/MM/yy') AND TO_DATE('"+$("#dtAgmExpiryTo").val()+"', 'dd/MM/yy')";
    }
    
   if($('#cboAgmStatus :selected').length > 0){
	   var result = "";
	   $('#cboAgmStatus :selected').each(function(i, mul){ 
		    result += $(mul).val();
		});

	   if(result == "ACTCOMCAN"){
		   whereSQL += " AND (ArgM.GOV_AG_STUS_ID='1' OR ArgM.GOV_AG_STUS_ID='4' OR ArgM.GOV_AG_STUS_ID='10')";
	   }else if(result == "ACTCOM"){
		   whereSQL += " AND (ArgM.GOV_AG_STUS_ID='1' OR ArgM.GOV_AG_STUS_ID='4')";
	   }else if(result == "ACTCAN"){
		   whereSQL += " AND (ArgM.GOV_AG_STUS_ID='1' OR ArgM.GOV_AG_STUS_ID='10')";
       }else if(result == "COMCAN"){
    	   whereSQL += " AND (ArgM.GOV_AG_STUS_ID='4' OR ArgM.GOV_AG_STUS_ID='10')";
       }else if(result == "ACT"){
    	   whereSQL += " AND ArgM.GOV_AG_STUS_ID='1'";
       }else if(result == "COM"){
    	   whereSQL += " AND ArgM.GOV_AG_STUS_ID='4'";
       }else if(result == "CAN"){
    	   whereSQL += " AND ArgM.GOV_AG_STUS_ID='10'";
       }
   }

   var action = "";
   action = $("#cmbSorting :selected").val();
   if(action == "1"){
	   orderSQL = " ORDER BY ArgM.GOV_AG_ID";
   }else if(action == "2"){
	   orderSQL = " ORDER BY OrM.SALES_ORD_NO";
   }else if(action == "3"){
	   orderSQL = " ORDER BY ArgM.GOV_AG_CRT_DT";
   }else if(action == "4"){
	   orderSQL = " ORDER BY ArgM.GOV_AG_TYPE_ID";
   }else if(action == "5"){
	   orderSQL = " ORDER BY ArgM.GOV_AG_PRGRS_ID";
   }
   
	var date = new Date().getDate();
    if(date.toString().length == 1){
		date = "0" + date;
	} 
    
    $("#viewType").val("PDF");
    $("#reportFileName").val("/sales/GovAgreementPDF.rpt");
    
    $("#reportDownFileName").val("AgrReport_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
	$("#V_WHERESQL").val(whereSQL);
	$("#V_ORDERBYSQL").val(orderSQL);
	
    // 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
    var option = {
        isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
    };

    Common.report("form", option);

}

function ValidRequiredField(){
    var valid = true;
    var message = "";
    
    if($("#dpDateFrom").val() == null || $("#dpDateFrom").val().length == 0){
        valid = false;
        message += "* Please key in the Created Date.\n";
    }

    if(valid == true){
        fn_report();
    }else{
    	Common.alert("Contract Agreement Generate Summary" + DEFAULT_DELIMITER + message);
    }
}

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Agreement Listing</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->

</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form">

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
    <th scope="row">Order No</th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="" placeholder="Order No (From)" class="w100p" id="txtOrderNo1"/></p>
    <span>To</span>
    <p><input type="text" title="" placeholder="Order No (To)" class="w100p" id="txtOrderNo2" /></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row">Agreement Type</th>
    <td>
    <select class="w100p" id="cmbAgrType">
        <option value="" hidden>Agreement Type</option>
        <option value="949">New</option>
        <option value="950">Renew</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Progress</th>
    <td>
    <select class="w100p" id="cmbProgress">
        <option value="" hidden>Progress</option>
        <option value="7">Submission Progress</option>
        <option value="8">Verifying Progress</option>
        <option value="9">Stamping & Confirmation Progress</option>
        <option value="10">Filling Progress</option>
    </select>
    </td>
    <th scope="row">CCP Status</th>
    <td>
    <select class="w100p" id="cmbCCPStatus">
        <option value="" hidden>CCP Status</option>
        <option value="1">Active</option>
        <option value="5">Approved</option>
        <option value="6">Rejected</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Created Date<span class="must">*</span></th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="dpDateFrom"/></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="dpDateTo"/></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row"></th>
    <td></td>
</tr>
<tr>
    <th scope="row">Agreement Start</th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="dtAgmStartFr"/></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="dtAgmStartTo"/></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row">Agreement Expiry</th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="dtAgmExpiryFr"/></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="dtAgmExpiryTo"/></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row">Sorting By</th>
    <td colspan="3">
    <select class="w100p" id="cmbSorting">
        <option value="1" >Sorting By AGM No</option>
        <option value="2">Sorting By Order No</option>
        <option value="3">Sorting By Created Date</option>
        <option value="4">Sorting By Agreement Type</option>
        <option value="5">Sorting By Progress</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Agreement Status</th>
    <td colspan="3"> 
    <select  multiple="multiple" class="multy_select w100p" id="cboAgmStatus" data-placeholder="Agreement Status">
        <option value="ACT">Active</option>
        <option value="COM">Completed</option>
        <option value="CAN">Cancelled</option>
    </select>
    
    </td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="right_btns">
    <li><p class="btn_blue"><a href="javascript:void(0);" onclick="javascript: ValidRequiredField();">Generate PDF</a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:$('#form').clearForm();"><span class="clear"></span>Clear</a></p></li>
</ul>


<input type="hidden" id="reportFileName" name="reportFileName" value="/sales/GovAgreementPDF.rpt" />
<input type="hidden" id="viewType" name="viewType" value="PDF" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />


<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" value="" />
<input type="hidden" id="V_ORDERBYSQL" name="V_ORDERBYSQL" value="" />


</form>



</section><!-- content end -->
     
</section><!-- container end -->

</div><!-- popup_wrap end -->