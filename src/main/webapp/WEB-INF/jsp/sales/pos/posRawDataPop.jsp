<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

$(document).ready(function() {

	 /*######################## Init Combo Box ########################*/
	 
	//PosModuleTypeComboBox
    var moduleParam = {groupCode : 143, codeIn : [2390, 2391]};
    CommonCombo.make('_cmbPosTypeId', "/sales/pos/selectPosModuleCodeList", moduleParam , '', optionModule);
    
    //PosSystemTypeComboBox
    var systemParam = {groupCode : 140 , codeIn : [1352, 1353 , 1361]};

    CommonCombo.make('_cmbSalesTypeId', "/sales/pos/selectPosModuleCodeList", systemParam , '', optionModule);
    
    //branch List
    CommonCombo.make('_cmbWhBrnchId', "/sales/pos/selectWhBrnchList", '' , '', '');
    
    ///getReasonCodeList
    var rsnParam = {masterCode : 1363};
    CommonCombo.make('_purcReason', "/sales/pos/getReasonCodeList", rsnParam , '', optionReasonChoose); //Reason Code List
    
    /*######################## Init Combo Box ########################*/
	
});

function fn_posRawData(){
	
	var option = {
            isProcedure : true 
    };
	
	var whereSql = '';
	
	if($("#_cmbPosTypeId").val() != null && $("#_cmbPosTypeId").val() != '' ){
		whereSql += " AND M.POS_MODULE_TYPE_ID = " + $("#_cmbPosTypeId").val();
	}
	
	if($("#_cmbSalesTypeId").val() != null && $("#_cmbSalesTypeId").val() != '' ){
		whereSql += " AND M.POS_TYPE_ID = " + $("#_cmbSalesTypeId").val();
	}
	
	if($("#_frPosNo").val() != null && $("#_frPosNo").val() != '' && $("#_toPosNo").val() != null && $("#_toPosNo").val() != ''){
		whereSql += " AND M.POS_NO BETWEEN " + $("#_frPosNo").val()+ " AND " + $("#_toPosNo").val();
	}
	
	if($("#_sttDate").val() != null && $("#_sttDate").val() != '' && $("#_eddDate").val() != null && $("#_eddDate").val() != '' ){
		whereSql += " AND M.POS_CRT_DT BETWEEN TO_DATE('" + $("#_sttDate").val()+ "', 'DD/MM/YYYY') AND TO_DATE('"+ $("#_eddDate").val() +"', 'DD/MM/YYYY')";
	}
	
	if($("#_cmbWhBrnchId").val() != null && $("#_cmbWhBrnchId").val() != '' ){
		whereSql += " AND M.BRNCH_ID  = " + $("#_cmbWhBrnchId").val();	
	}
	
    var runReason = 0;
    var resnStr = '';
    if($('#_purcReason :selected').length > 0){
        $('#_purcReason :selected').each(function(idx, el){ 
            if(runReason > 0){
            	resnStr += ',' + $(el).val();
            }else{
            	resnStr += $(el).val();
            }
            runReason += 1;
        });
    }
    
    if(resnStr != null && resnStr != ''){
    	whereSql += " AND M.POS_RESN_ID  IN (  "+resnStr+ ") ";   
    }
    
    if($("#_hidSalesAgentId").val() != null && $("#_hidSalesAgentId").val() != '' ){
    	whereSql += " AND M.POS_CRT_USER_ID = " + $("#_hidSalesAgentId").val() + " ";  //hidden Sales Man ID
    }
    
    if($("#_hidMemberCode").val() != null && $("#_hidMemberCode").val() != ''){
    	whereSql += " AND M.POS_MEM_ID = " + $("#_hidMemberCode").val() + " ";  //hidden Member ID
    }
    
    console.log("whereSql : " + whereSql);
    
    //params Setting
    $("#reportFileName").val("/sales/POSRawData_Filter.rpt");
    $("#viewType").val("EXCEL");
    //
    $("#V_WHERESQL").val(whereSql);
    
    Common.report("rptForm", option);
	
}

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>POS Raw Data</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="_itmSrchPopClose">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<form action="#" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">POS Type</th>
    <td>
    <select class="w100p" id="_cmbPosTypeId"></select>
    </td>
    <th scope="row">POS Sales Type</th>
    <td>
    <select class="w100p" id="_cmbSalesTypeId"></select>
    </td>
</tr>
<tr>
    <th scope="row">POS No.</th>
    <td>
    <input type="text" title="" placeholder="From POS No."   style="width: 45%" id="_frPosNo"  />
    <input type="text" title="" placeholder="To POS No."  style="width: 45%" id="_toPosNo" />
    </td>
    <th scope="row">Sales Date</th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date"  name="sDate" id="_sttDate" value="${bfDay}"/></p>  
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" name="eDate"  id="_eddDate" value="${toDay}"/></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row">Branch / Warehouse</th>
    <td><select  id="_cmbWhBrnchId"  name="" class="w100p"></select></td>
    <!-- Reason -->
    <th scope="row">Purchase Reason</th>
    <td><select  id="_purcReason"  name="" class="w100p"></select></td>
</tr>
<tr>
    <th scope="row">Sales Agent</th>
    <td>
    <input type="text" title="" placeholder="Sales Agent" class="w100p" id="_salesAgent" />
    <input type="hidden" id="_hidSalesAgentId">
    </td>
    <th scope="row">Member Code</th>
    <td>
    <input type="text" title="" placeholder="Member Code" class="w100p" id="_memberCode" />
    <input type="hidden" id="_hidMemberCode">
    </td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a onclick="javascript: fn_posRawData()" >Generate</a></p></li>
    <li><p class="btn_blue2 big"><a href="#" >Clear</a></p></li>
</ul>
</form>
</section>
</div>