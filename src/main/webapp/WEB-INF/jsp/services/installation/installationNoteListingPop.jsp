<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
var myGridID;
$(document).ready(function(){
     $('.multy_select').on("change", function() {
           //console.log($(this).val());
       }).multipleSelect({}); 
    
    doGetCombo('/common/selectCodeList.do', '10', '','appliType', 'M' , 'f_multiCombo'); 
    doGetComboSepa("/common/selectBranchCodeList.do",5 , '-',''   , 'branch' , 'M', 'f_multiCombo1'); 
    doGetProductCombo('/common/selectProductCodeList.do', '', '', 'product', 'M','f_multiCombo2'); //Product Code
    fn_noteListingGrid();
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
function f_multiCombo2() {

    $('#product').change(function() {
    }).multipleSelect({
        selectAll : true,
        width : '80%'
    });
}

function fn_noteListingGrid() {
    //AUIGrid 칼럼 설정
    var columnLayout = [ {
        dataField : "instno",
        //headerText : "Inst No",
        headerText : '<spring:message code="service.grid.InstNo" />',
        editable : false,
        width : 130
    }, {
        dataField : "orderno",
        //headerText : "Order No",
        headerText : '<spring:message code="service.grid.OrderNo" />',
        editable : false,
        width : 130
    }, {
        dataField : "custname",
        //headerText : "Cust Name",
        headerText : '<spring:message code="service.grid.CustName" />',        
        editable : false,
        width : 130
    }, {
        dataField : "areaname",
        //headerText : "Area Name",
        headerText : '<spring:message code="service.grid.AreaName" />',
        editable : false,
        width : 130
    }, {
        dataField : "appdate",
        //headerText : "App Date",
        headerText : '<spring:message code="service.grid.AppDate" />',
        editable : false,
        style : "my-column",
        width : 130
    }, {
        dataField : "dodate",
        //headerText : "Do Date",
        headerText : '<spring:message code="service.grid.DoDate" />',
        editable : false,
        width : 130
    }, {
        dataField : "instdate",
        //headerText : "Inst Date",
        headerText : '<spring:message code="service.grid.InstDate" />',
        editable : false,
        width : 130
        
    }, {
        dataField : "ctcode",
        //headerText : "CT Code",
        headerText : '<spring:message code="service.grid.CTCode" />',
        editable : false,
        width : 130
    }, {
        dataField : "product",
        //headerText : "Product",
        headerText : '<spring:message code="service.grid.Product" />',
        editable : false,
        width : 130
    }, {
        dataField : "apptype",
        //headerText : "App Type",
        headerText : '<spring:message code="service.grid.AppType" />',
        editable : false,
        width : 130
    }, {
        dataField : "orderstatus",
        //headerText : "Order Status",
        headerText : '<spring:message code="service.grid.OrderStatus" />',
        editable : false,
        width : 130
    }, {
        dataField : "inststatus",
        //headerText : "Ins Status",
        headerText : '<spring:message code="service.grid.InsStatus" />',
        editable : false,
        width : 130
    }];
     // 그리드 속성 설정
    var gridPros = {
        
             usePaging           : true,         //페이징 사용
             pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)            
             editable            : false,            
             fixedColumnCount    : 1,            
             showStateColumn     : false,             
             displayTreeOpen     : false,            
             selectionMode       : "singleRow",  //"multipleCells",            
             headerHeight        : 30,       
             useGroupingPanel    : false,        //그룹핑 패널 사용
             skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
             wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
             showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    

    };
    
    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
    myGridID = AUIGrid.create("#grid_wrap_noteListing", columnLayout, gridPros);
}

var gridPros = {
    
    // 페이징 사용       
    usePaging : true,
    
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
    
    editable : true,
    
    fixedColumnCount : 1,
    
    showStateColumn : true, 
    
    displayTreeOpen : true,
    
    selectionMode : "singleRow",
    
    headerHeight : 30,
    
    // 그룹핑 패널 사용
    useGroupingPanel : true,
    
    // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
    skipReadonlyColumns : true,
    
    // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
    wrapSelectionMove : true,
    
    // 줄번호 칼럼 렌더러 출력
    showRowNumColumn : false
    
};
function fn_validation(){
	if($("#doCrtDate").val() != '' || $("#doEndDate").val() != ''){
        if($("#doCrtDate").val() == '' || $("#doEndDate").val() == ''){
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='DO date (From & To)' htmlEscape='false'/>");
            return false;
        }
    }
	if($("#orderStrDate").val() != '' || $("#orderEndDate").val() != ''){
        if($("#orderStrDate").val() == '' || $("#orderEndDate").val() == ''){
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='Order Date (From & To)' htmlEscape='false'/>");
            return false;
        }
    }
	if($("#appStrDate").val() != '' || $("#appEndDate").val() != ''){
        if($("#appStrDate").val() == '' || $("#appEndDate").val() == ''){
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='Appointment date (From & To)' htmlEscape='false'/>");
            return false;
        }
    }
	if($("#orderNoFrom").val() != '' || $("#orderNoTo").val() != ''){
        if($("#orderNoFrom").val() == '' || $("#orderNoTo").val() == ''){
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='Order Number (From & To)' htmlEscape='false'/>");
            return false;
        }
    }
	if($("#CTCodeFrom").val() != '' || $("#CTCodeTo").val() != ''){
        if($("#CTCodeFrom").val() == '' || $("#CTCodeTo").val() == ''){
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='CT code (From & To)' htmlEscape='false'/>");
            return false;
        }
    }
	return true;
}
function fn_openReport(){
	if(fn_validation()){
		var whereSql = "";
		var DSCCode = "";
		var appDate = "";
		var date = new Date();
		var month = date.getMonth()+1;
		 var day =date.getDate();
         if(date.getDate() < 10){
            day = "0"+date.getDate();
            }
		if($("#appStrDate").val() != '' && $("#appEndDate").val() != ''){
			appDate = $("#appStrDate").val() + " To "+ $("#appEndDate").val();
			whereSql +=" AND (ie.Install_Dt between to_date('"  + $("#appStrDate").val() + "', 'DD/MM/YYYY') AND to_date('" +$("#appEndDate").val()  + "', 'DD/MM/YYYY') ) ";
        }
		if($("#branch").val() != '' && $("#branch").val() != null){
			DSCCode = $("#branch option:selected").text();
			whereSql += "AND I.brnch_ID IN ( " + $("#branch").val() + ")  ";
	    }
		if($("#product").val() != '' && $("#product").val() != null ){
			whereSql += "AND ie.INSTALL_STK_ID IN ( " + $("#product").val() + ")  ";
        }
		if($("#status").val() != '' && $("#status").val() != null ){
			whereSql += "AND ie.stus_Code_ID IN ( " + $("#status").val() + ")  ";
        }
		if($("#installType").val() != '' && $("#installType").val() != null){
			whereSql += "AND ce.Type_ID IN ( " + $("#installType").val() + ")  ";
	    }
		if($("#status").val() != '' && $("#status").val() != null){
			whereSql += "AND  ce.Type_ID  IN ( " + $("#installType").val() + ")  ";
        }
		if($("#doCrtDate").val() != '' && $("#doEndDate").val() != ''){
			whereSql +=" AND (sm.MOV_UPD_DT between to_date('"  + $("#doCrtDate").val() + "', 'DD/MM/YYYY') AND to_date('" +$("#doEndDate").val()  + "', 'DD/MM/YYYY') ) ";
        }
		if($("#appliType").val() != '' && $("#appliType").val() != null){
			whereSql +=" AND som.App_Type_ID IN(" + $("#appliType").val() + ") ";
        }
		var orderDate ="";
		if($("#orderStrDate").val() != '' && $("#orderEndDate").val() != ''){
			orderDate = $("#orderStrDate").val() + " To " + $("#orderEndDate").val()
            whereSql +=" AND (som.Sales_Dt between to_date('"  + $("#orderStrDate").val() + "', 'DD/MM/YYYY') AND to_date('" +$("#orderEndDate").val()  + "', 'DD/MM/YYYY') ) ";
        }
		if($("#CTCodeFrom").val() != '' && $("#CTCodeTo").val() != ''){
			whereSql +=" AND (m.mem_code between '"  + $("#CTCodeFrom").val() + "' AND '" +$("#CTCodeTo").val()  + "') ";
        }
		if($("#orderNoFrom").val() != '' && $("#orderNoTo").val() != ''){
			whereSql +=" AND (som.Sales_Ord_No between'"  + $("#orderNoFrom").val() + "' AND '" +$("#orderNoTo").val()  + "') ";
        }
		var orderBySql = " ORDER BY ie.Install_Entry_No "
            if($("#sortType").val() == "1"){
                orderBySql = " ORDER BY ie.Install_Entry_No ";
            }else if(($("#sortType").val() == "2")){
                orderBySql = " ORDER BY loc.WH_LOC_CODE ";
            }else if(($("#sortType").val() == "3")){
                orderBySql = " ORDER BY som.Sales_Ord_No ";
            }else if(($("#sortType").val() == "4")){
                orderBySql = " ORDER BY stk.StkDesc ";
            }else if(($("#sortType").val() == "5")){
                orderBySql = " ORDER BY c.Name ";
            }else if(($("#sortType").val() == "6")){
                orderBySql = " ORDER BY t.Code ";
            }else if(($("#sortType").val() == "7")){
                orderBySql = " ORDER BY s2.Code ";
            }
		
		$("#reportForm #V_DSCCODE").val(DSCCode);
		$("#reportForm #V_APPDATE").val(appDate);
		$("#reportForm #V_ORDERDATE").val(orderDate);
		$("#reportForm #V_WHERESQL").val(whereSql);
		$("#reportForm #V_ORDERBYSQL").val(orderBySql);
		$("#reportForm #reportFileName").val('/services/InstallationNoteListing_PDF.rpt');
	     $("#reportForm #viewType").val("PDF");
	     $("#reportForm #reportDownFileName").val("InstallationNoteList_"+day+month+date.getFullYear());
	     
		var option = {
                isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
        };
        
        Common.report("reportForm", option);
	}
}

function fn_searchView(){
	
	if(fn_validation()){
        var whereSql = "";
        var DSCCode = "";
        var appDate = "";
        var date = new Date();
        var month = date.getMonth()+1;
        var day = date.getDate();
        if(date.getDate() < 10){
            day = "0"+date.getDate();
        }
        if($("#appStrDate").val() != '' && $("#appEndDate").val() != ''){
            appDate = $("#appStrDate").val() + " To "+ $("#appEndDate").val();
            whereSql +=" AND (ie.Install_Dt between to_date('"  + $("#appStrDate").val() + "', 'DD/MM/YYYY') AND to_date('" +$("#appEndDate").val()  + "', 'DD/MM/YYYY') ) ";
        }
        if($("#branch").val() != '' && $("#branch").val() != null){
            DSCCode = $("#branch option:selected").text();
            whereSql += "AND I.brnch_ID IN ( " + $("#branch").val() + ")  ";
        }
        if($("#product").val() != '' && $("#product").val() != null ){
            whereSql += "AND ie.INSTALL_STK_ID IN ( " + $("#product").val() + ")  ";
        }
        if($("#status").val() != '' && $("#status").val() != null ){
            whereSql += "AND ie.stus_Code_ID IN ( " + $("#status").val() + ")  ";
        }
        if($("#installType").val() != '' && $("#installType").val() != null){
            whereSql += "AND ce.Type_ID IN ( " + $("#installType").val() + ")  ";
        }
        if($("#status").val() != '' && $("#status").val() != null){
            whereSql += "AND  ce.Type_ID  IN ( " + $("#installType").val() + ")  ";
        }
        if($("#doCrtDate").val() != '' && $("#doEndDate").val() != ''){
            whereSql +=" AND (sm.MOV_UPD_DT between to_date('"  + $("#doCrtDate").val() + "', 'DD/MM/YYYY') AND to_date('" +$("#doEndDate").val()  + "', 'DD/MM/YYYY') ) ";
        }
        if($("#appliType").val() != '' && $("#appliType").val() != null){
            whereSql +=" AND som.App_Type_ID IN(" + $("#appliType").val() + ") ";
        }
        var orderDate ="";
        if($("#orderStrDate").val() != '' && $("#orderEndDate").val() != ''){
            orderDate = $("#orderStrDate").val() + " To " + $("#orderEndDate").val()
            whereSql +=" AND (som.Sales_Dt between to_date('"  + $("#orderStrDate").val() + "', 'DD/MM/YYYY') AND to_date('" +$("#orderEndDate").val()  + "', 'DD/MM/YYYY') ) ";
        }
        if($("#CTCodeFrom").val() != '' && $("#CTCodeTo").val() != ''){
            whereSql +=" AND (m.mem_code between '"  + $("#CTCodeFrom").val() + "' AND '" +$("#CTCodeTo").val()  + "') ";
        }
        if($("#orderNoFrom").val() != '' && $("#orderNoTo").val() != ''){
            whereSql +=" AND (som.Sales_Ord_No between'"  + $("#orderNoFrom").val() + "' AND '" +$("#orderNoTo").val()  + "') ";
        }
        var orderBySql = " ORDER BY ie.Install_Entry_No "
            if($("#sortType").val() == "1"){
                orderBySql = " ORDER BY ie.Install_Entry_No ";
            }else if(($("#sortType").val() == "2")){
                orderBySql = " ORDER BY loc.WH_LOC_CODE ";
            }else if(($("#sortType").val() == "3")){
                orderBySql = " ORDER BY som.Sales_Ord_No ";
            }else if(($("#sortType").val() == "4")){
                orderBySql = " ORDER BY stk.StkDesc ";
            }else if(($("#sortType").val() == "5")){
                orderBySql = " ORDER BY c.Name ";
            }else if(($("#sortType").val() == "6")){
                orderBySql = " ORDER BY t.Code ";
            }else if(($("#sortType").val() == "7")){
                orderBySql = " ORDER BY s2.Code ";
            }
        
        $("#reportForm #V_DSCCODE").val(DSCCode);
        $("#reportForm #V_APPDATE").val(appDate);
        $("#reportForm #V_ORDERDATE").val(orderDate);
        $("#reportForm #V_WHERESQL").val(whereSql);
        $("#reportForm #V_ORDERBYSQL").val(orderBySql);
        $("#reportForm #reportFileName").val('/services/InstallationNoteListing_PDF.rpt');
         $("#reportForm #viewType").val("PDF");
         $("#reportForm #reportDownFileName").val("InstallationNoteList_"+day+month+date.getFullYear());
         
        var option = {
                isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
        };
        
        Common.ajax("GET", "/services/selectInstallationNoteListing.do", $("#reportForm").serialize(), function(result) {
            console.log("성공.");
            console.log("data : " + result);
            AUIGrid.setGridData(myGridID, result);
        });
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
            f_multiCombo2();
        }
    });
};
</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code='service.btn.InstallationNoteListing'/></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code='expense.CLOSE'/></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" id="reportForm">
<input type="hidden" id="V_DSCCODE" name="V_DSCCODE" />
<input type="hidden" id="V_APPDATE" name="V_APPDATE" />
<input type="hidden" id="V_ORDERDATE" name="V_ORDERDATE" />
<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" />
<input type="hidden" id="V_ORDERBYSQL" name="V_ORDERBYSQL" />
<!--reportFileName,  viewType 모든 레포트 필수값 -->
<input type="hidden" id="reportFileName" name="reportFileName" />
<input type="hidden" id="viewType" name="viewType" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="DOWN_FILE_NAME" />
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
    <th scope="row"><spring:message code='service.title.Type'/></th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="installType" name="installType">
        <option value="257">New Installation</option>
        <option value="258">Product Exchange</option>
    </select>
    </td>
    <th scope="row"><spring:message code='service.title.AppointmentDate'/></th>    
    <td>

    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="appStrDate" name="appStrDate"/></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="appEndDate" name="appEndDate"/></p>
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
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="doCrtDate" name="doCrtDate"/></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="doEndDate" name="doEndDate"/></p>
    </div><!-- date_set end -->

    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='service.title.ApplicationType'/></th>
    <td>
    <select class="multy_select" multiple="multiple"  id="appliType" name="appType">
    </select>
    </td>
    <th scope="row"><spring:message code='service.title.OrderDate'/></th>    
    <td>

    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="orderStrDate" name="orderStrDate"/></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="orderEndDate" name="orderEndDate"/></p>
    </div><!-- date_set end -->

    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='service.title.CTCode'/></th>    
    <td>

    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="" placeholder="" class="w100p" id="CTCodeFrom" name="CTCodeFrom" /></p>
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
        <option value="4">Product</option>
        <option value="5">Customer Name</option>
        <option value="6">Application Type</option>
        <option value="7">Install Status</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Order Number</th>
    <th scope="row"><spring:message code='service.title.OrderNumber'/></th>    
    <td>

    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="" placeholder="" class="w100p" id="orderNoFrom" name="orderNoFrom" /></p>
    <span>To</span>
    <p><input type="text" title="" placeholder="" class="w100p" id="orderNoTo" name="orderNoTo" /></p>
    </div><!-- date_set end -->

    </td>
    <th scope="row"><spring:message code='service.title.Status'/></th>
    <td>
    <select class="multy_select" multiple="multiple" id="status" name="status">
        <option value="1">Active</option>
        <option value="4">Complete</option>
        <option value="21">Fail</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='service.title.Product'/></th>    
    <td colspan="3">
    <select class="multy_select" multiple="multiple" id="product" name="product">
    </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->
</form>
</section><!-- search_table end -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_wrap_noteListing" style="width: 100%; height: 300px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_searchView()"><spring:message code='service.btn.View'/></a></p></li>
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_openReport()"><spring:message code='service.btn.Generate'/></a></p></li>
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:$('#reportForm').clearForm();"><spring:message code='service.btn.Clear'/></a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
