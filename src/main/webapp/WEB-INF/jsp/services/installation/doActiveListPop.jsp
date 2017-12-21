<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
$(document).ready(function(){
	 $('.multy_select').on("change", function() {
         //console.log($(this).val());
     }).multipleSelect({});
  
	 doGetCombo('/common/selectCodeList.do', '10', '','appliType', 'M' , 'f_multiCombo'); 
	 doGetComboSepa("/common/selectBranchCodeList.do",5 , '-',''   , 'branch' , 'M', 'f_multiCombo1');
   
});

function f_multiCombo() {
       
        $('#appliType').change(function() {
        }).multipleSelect({
            selectAll : true,
            width : '80%'
        });
}
function f_multiCombo1() {
    
	    $('#branch').change(function() {
	    }).multipleSelect({
	        selectAll : true,
	        width : '80%'
	    });
}

function fn_Validation(){
	//if (branch.CheckedItems.Count < 1)
    if($("#branch option:selected").length < 1)
    {
		Common.alert("<spring:message code='sys.common.alert.validation' arguments='DSC Branch' htmlEscape='false'/>");
		return false;
    }
	if($("#installCrtDt").val() != '' || $("#installEndDt").val() != ''){
		if($("#installCrtDt").val() == '' || $("#installEndDt").val() == ''){
			Common.alert("<spring:message code='sys.common.alert.validation' arguments='Install date (From & To)' htmlEscape='false'/>");
			return false;
		}
	}
	if($("#doCrtDt").val() != '' || $("#doEndDt").val() != ''){
        if($("#doCrtDt").val() == '' || $("#doEndDt").val() == ''){
            Common.alert("<spring:message code='sys.common.alert.validation' arguments= 'DO date (From & To)' htmlEscape='false'/>");
            return false;
        }
    }
	if($("#ordStrDt").val() != '' || $("#ordEndDt").val() != ''){
        if($("#ordStrDt").val() == '' || $("#ordEndDt").val() == ''){
            Common.alert("<spring:message code='sys.common.alert.validation' arguments= 'Order date (From & To) ' htmlEscape='false'/>");
            return false;
        }
    }
	if($("#CTCodeFrom").val() != '' || $("#CTCodeTo").val() != ''){
        if($("#CTCodeFrom").val() == '' || $("#CTCodeTo").val() == ''){
            Common.alert("<spring:message code='sys.common.alert.validation' arguments= 'CT code (From & To)' htmlEscape='false'/>");
            return false;
        }
    }
	if($("#orderNumFr").val() != '' || $("#orderNumTo").val() != ''){
        if($("#orderNumFr").val() == '' || $("#orderNumTo").val() == ''){
            Common.alert("<spring:message code='sys.common.alert.validation' arguments= 'Order number (From & To)' htmlEscape='false'/>");
            return false;
        }
    }
	return true
}

function fn_Generate(){
	if(fn_Validation()){
		var date = new Date();
		var month = date.getMonth()+1;
		 var day = date.getDate();
	        if(date.getDate() < 10){
	            day = "0"+date.getDate();
	        }
		var runNo = 0;
		var whereSql = "";
		var selectListing = "";
		selectListing = $("#type").val();
		var instdateFrm = "";
		var instdateTo = "";
		var DodateFrm = "";
		var DodateTo = "";
		var appType="";
		var OrderdateFrm = "";
		var OrderdateTo = "";
		var CTCode = "";
		var orderNoFrm = "";
		var orderNoTo = "";
		if($("#installCrtDt").val() != '' && $("#installEndDt").val() != ''){
			instdateFrm  = $("#installCrtDt").val();
			instdateTo = $("#installEndDt").val();
			whereSql +=" AND (inse.Install_Dt between to_date('"  + $("#installCrtDt").val() + "', 'DD/MM/YYYY') AND to_date('" +$("#installEndDt").val()  + "', 'DD/MM/YYYY') ) ";
	    }
		if($("#branch").val() != ''){
			whereSql += " AND branch.brnch_id In (" + $("#branch").val() + ") ";
	    }
		if($("#doCrtDt").val() != '' && $("#doEndDt").val() != ''){
			DodateFrm = $("#doCrtDt").val();
			DodateTo = $("#doEndDt").val();
			whereSql +=" AND inv.MOV_STUS_ID = 4 and inv.MOV_CNFM = 1 AND (inv.MOV_UPD_DT between to_date('"  + $("#doCrtDt").val() + "', 'DD/MM/YYYY') AND to_date('" +$("#doEndDt").val()  + "', 'DD/MM/YYYY') ) ";
	    }
		if($("#appliType").val() != '' && $("#appliType").val() != null){
			appType = $("#appliType").val();
			whereSql +=" AND tm.App_Type_ID IN(" + $("#appliType").val() + ") ";
	    }
		if($("#ordStrDt").val() != '' && $("#ordEndDt").val() != ''){
			OrderdateFrm = $("#ordStrDt").val();
			OrderdateTo = $("#ordEndDt").val();
			whereSql +=" AND (tm.Sales_DT between to_date('"  + $("#ordStrDt").val() + "', 'DD/MM/YYYY') AND to_date('" +$("#ordEndDt").val()  + "', 'DD/MM/YYYY') ) ";
	    }
		if($("#CTCodeFrom").val() != '' && $("#CTCodeTo").val() != ''){
			CTCode = $("#CTCodeFrom").val() + " To " + $("#CTCodeTo").val();
			whereSql +=" AND (CTMem.mem_code between '"  + $("#CTCodeFrom").val() + "' AND '" +$("#CTCodeTo").val()  + "') ";
	    }
		if($("#orderNumFr").val() != '' && $("#orderNumTo").val() != ''){
			orderNoFrm = $("#orderNumFr").val();
			orderNoTo = $("#orderNumTo").val();
			whereSql +=" AND (tm.Sales_Ord_No between '"  + $("#orderNumFr").val() + "' AND '" +$("#orderNumTo").val()  + "') ";
	    }
		
		var orderBySql = " ORDER BY inse.Install_Entry_ID "
			if($("#sortType").val() == "1"){
				orderBySql = " ORDER BY inse.Install_Entry_No ";
			}else if(($("#sortType").val() == "2")){
				orderBySql = " ORDER BY CTmem.mem_code ";
			}else if(($("#sortType").val() == "3")){
				orderBySql = " ORDER BY tm.Sales_Ord_No ";
	        }
		$("#installationActiveForm #V_SELECTLISTING").val(selectListing);
		$("#installationActiveForm #V_ORDERNOFRM").val(orderNoFrm);
		$("#installationActiveForm #V_ORDERNOTO").val(orderNoTo);
		$("#installationActiveForm #V_ORDERDATEFRM").val(OrderdateFrm);
		$("#installationActiveForm #V_ORDERDATETO").val(OrderdateTo);
		$("#installationActiveForm #V_INSTDATEFRM").val(instdateFrm);
		$("#installationActiveForm #V_INSTDATETO").val(instdateTo);
		$("#installationActiveForm #V_DODATEFRM").val(DodateFrm);
		$("#installationActiveForm #V_DODATETO").val(DodateTo);
		$("#installationActiveForm #V_APPTYPE").val(appType);
		$("#installationActiveForm #V_CTCODE").val(CTCode);
		$("#installationActiveForm #V_STKGRADE").val("A");
		$("#installationActiveForm #V_ORDERBYSQL").val(orderBySql);
		$("#installationActiveForm #V_SELECTSQL").val("A");
		$("#installationActiveForm #V_WHERESQL").val(whereSql);
		$("#installationActiveForm #V_FULLSQL").val("A");
		$("#installationActiveForm #reportFileName").val('/services/ActiveInstallList.rpt');
		$("#installationActiveForm #viewType").val("PDF");
		$("#installationActiveForm #reportDownFileName").val("DOActiveList_"+day+month+date.getFullYear());
		
		 var option = {
	             isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
	     };
	     
	     Common.report("installationActiveForm", option);
	}
}

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
	            this.selectedIndex = -1;
	            f_multiCombo();
	            f_multiCombo1();
	        }
	    });
	};
</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code='service.title.DOActiveList'/></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code='expense.CLOSE'/></a></p></li> 
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form  method="post" id="installationActiveForm" name="installationActiveForm">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:120px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code='service.title.Type'/></th>
    <td>
    <select class="disabled" disabled="disabled" id="type" name="type">
        <option value=""></option>
        <option value="1">Active Installation (DO Ready)</option>
        <option value="2">Active Installation (DO Posted)</option>
        <option value="3">Active Installation (Call Log Ready)</option>
    </select>
    </td>
    <th scope="row"><spring:message code='service.title.InstallDate'/></th>
    <td>

    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="installCrtDt" name="installCrtDt"/></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="installEndDt" name="installEndDt"/></p>
    </div><!-- date_set end -->

    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='service.title.DSCBranch'/></th>    
    <td>
    <select class="multy_select" multiple="multiple" id="branch" name="branch">
    </select>
    </td>
    <th scope="row"><spring:message code='service.title.DODate'/></th>
    <td>

    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="doCrtDt" name="doCrtDt"/></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="doEndDt" name="doEndDt"/></p>
    </div><!-- date_set end -->

    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='service.title.ApplicationType'/></th>
    <td>
    <select class="multy_select" multiple="multiple" id="appliType" name="appliType"> 
    </select>
    </td>
    <th scope="row"><spring:message code='service.title.OrderDate'/></th>
    <td>

    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="ordStrDt" name="ordStrDt"/></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="ordEndDt" name="ordEndDt"/></p>
    </div><!-- date_set end -->

    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='service.title.CTCode'/></th>
    <td>

    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="" placeholder="" class="w100p" id="CTCodeFrom" name="CTCodeFrom"/></p>
    <span>To</span>
    <p><input type="text" title="" placeholder="" class="w100p" id="CTCodeTo" name="CTCodeTo"/></p>
    </div><!-- date_set end -->

    </td>
    <th scope="row"><spring:message code='service.title.SortBy'/></th>    
    <td>
    <select id="sortType" name="sortType">
        <option value=""></option>
        <option value="1">Installation Number</option>
        <option value="2">CT Code</option>
        <option value="3">Order Number</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='service.title.OrderNumber'/></th>    
    <td colspan="3">

    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="" placeholder="" class="w100p" id="orderNumFr" name="orderNumFr"/></p>
    <span>To</span>
    <p><input type="text" title="" placeholder="" class="w100p" id="orderNumTo" name="orderNumTo"/></p>
    </div><!-- date_set end -->

    </td>
</tr>
</tbody>
</table><!-- table end -->

<input type="hidden" id="V_SELECTLISTING" name="V_SELECTLISTING" />
<input type="hidden" id="V_ORDERNOFRM" name="V_ORDERNOFRM" />
<input type="hidden" id="V_ORDERNOTO" name="V_ORDERNOTO" />
<input type="hidden" id="V_ORDERDATEFRM" name="V_ORDERDATEFRM" />
<input type="hidden" id="V_ORDERDATETO" name="V_ORDERDATETO" />
<input type="hidden" id="V_INSTDATEFRM" name="V_INSTDATEFRM" />
<input type="hidden" id="V_INSTDATETO" name="V_INSTDATETO" />
<input type="hidden" id="V_DODATEFRM" name="V_DODATEFRM" />
<input type="hidden" id="V_DODATETO" name="V_DODATETO" />
<input type="hidden" id="V_APPTYPE" name="V_APPTYPE" />
<input type="hidden" id="V_CTCODE" name="V_CTCODE" />
<input type="hidden" id="V_STKGRADE" name="V_STKGRADE" />
<input type="hidden" id="V_ORDERBYSQL" name="V_ORDERBYSQL" />
<input type="hidden" id="V_SELECTSQL" name="V_SELECTSQL" />
<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" />
<input type="hidden" id="V_FULLSQL" name="V_FULLSQL" />
<!--reportFileName,  viewType 모든 레포트 필수값 -->
<input type="hidden" id="reportFileName" name="reportFileName" />
<input type="hidden" id="viewType" name="viewType" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="DOWN_FILE_NAME" />

</form>
</section><!-- search_table end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_Generate()"><spring:message code='service.btn.Generate'/></a></p></li>
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:$('#installationActiveForm').clearForm();"><spring:message code='service.btn.Clear'/></a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
</body>
</html>