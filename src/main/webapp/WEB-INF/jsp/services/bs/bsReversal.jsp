<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
	$(document).ready(function() {
		
		
        
	    // AUIGrid 그리드를 생성합니다.
	    createAUIGrid();
	    
	    AUIGrid.setSelectionMode(myGridID, "singleRow");
	    
	    AUIGrid.bind(myGridID, "cellClick", function(event) {
	        //alert(event.rowIndex+ " -cellClick : " + event.value + " - rowValue : " + AUIGrid.getCellValue(myGridID, event.rowIndex, "memberid"));
	        no =  AUIGrid.getCellValue(myGridID, event.rowIndex, "no");
	        salesOrdNo = AUIGrid.getCellValue(myGridID, event.rowIndex, "salesOrdNo");
	        memCode = AUIGrid.getCellValue(myGridID, event.rowIndex, "memCode");
	        name = AUIGrid.getCellValue(myGridID, event.rowIndex, "name");
	        resultCrtDt = AUIGrid.getCellValue(myGridID, event.rowIndex, "resultCrtDt");
	        custId = AUIGrid.getCellValue(myGridID, event.rowIndex, "custId");
	        stusCodeId = AUIGrid.getCellValue(myGridID, event.rowIndex, "stusCodeId");
	        salesOrdId = AUIGrid.getCellValue(myGridID, event.rowIndex, "salesOrdId");
	        //Common.popupDiv("/organization/requestTerminateResign.do?isPop=true&MemberID=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "memberid")+"&MemberType=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "membertype"), "");
	        
	        selectrow(salesOrdId);
	    });
	    
	});
	
	function fn_getHSConfigBasicInfo(){
        Common.ajax("GET", "/services/bs/getHSConfigBasicInfo.do", $("#frmBasicInfo").serialize(), function(result) {
        console.log("fn_getHSConfigBasicInfo.");
        
        console.log("cmbServiceMemList {}" + result);
         });
    }
	
	
	function createAUIGrid() {
	    //AUIGrid 칼럼 설정
	    var columnLayout = [ {
	        dataField : "no",
	        headerText : "No.",
	        editable : true,
	        width : 50
	    }, {
	        dataField : "salesOrdNo",
	        headerText : "Sales Order No",
	        editable : false,
	        width : 120
	    }, {
	        dataField : "memCode",
	        headerText : "member code",
	        editable : false,
	        width : 130
	    }, {
	        dataField : "name",
	        headerText : "name",
	        editable : false,
	        width : 130
	    }, {
	        dataField : "resultCrtDt",
	        headerText : "Result Created Date",
	        editable : false,
	        style : "my-column",
	        width : 150
	    }, {
	        dataField : "custId",
	        headerText : "Customer ID",
	        editable : false,
	        width : 130
	    }, {
	        dataField : "stusCodeId",
	        headerText : "Status Code ID",
	        editable : false,
	        width : 130

	    }, {
            dataField : "salesOrdId",
            headerText : "salesOrdId",
            editable : false,
            width : 0

        }];


	     // 그리드 속성 설정
	    var gridPros = {

	             usePaging           : false,         //페이징 사용
	             pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)
	             editable            : false,
	             fixedColumnCount    : 1,
	             showStateColumn     : false,
	             displayTreeOpen     : false,
	             selectionMode       : "singleRow",  //"multipleCells",
	             headerHeight        : 20,
	             useGroupingPanel    : false,        //그룹핑 패널 사용
	             skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
	             wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
	             showRowNumColumn    : false       //줄번호 칼럼 렌더러 출력
	    };

	    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
	    myGridID = AUIGrid.create("#grid_wrap_memList", columnLayout, gridPros);
	}
	
	function fn_orderSearch(){
	    Common.ajax("GET", "/services/bs/bsReversalSearch", $("#searchForm").serialize(), function(orderList) {
	        console.log("성공.");
	        //console.log("data : " + orderList);
	        AUIGrid.setGridData(myGridID, orderList);
	    });

	}
	
	function selectrow(salesOrdId){
	    $("#salesOrdId").val(salesOrdId);
	    
	    Common.ajax("POST", "/services/bs/bsReversalSearchDetail", $("#searchForm").serializeJSON() , function(result) {
        fn_setdetail(result);
         }, function(jqXHR, textStatus, errorThrown) {
             
             console.log("실패하였습니다.");
             console.log("error : " + jqXHR + " \n " + textStatus + "\n" + errorThrown);

             console.log("jqXHR.responseJSON.message" + jqXHR.responseJSON.message);
             
         });

	}
	
	function fn_setdetail(result){
	    alert("resultSet");
	    
	    $("#entry_orderNo").val(result.list1.ordNo);
	    $("#entry_appType").val(result.list1.appTypeCode);
	    $("#entry_address").val(result.list1.appTypeCode);
	    $("#entry_product").val(result.list1.stock);
	    $("#entry_custName").val(result.list1.custName);
	    $("#entry_nric").val(result.list1.custNric);
	    
	    $("#entry_lstHSDate").val(result.list1.c4);
	    $("#entry_remark").text(result.list1.configBsRem);
	    
	    
	    if(result.list1.configSettIns==1)
	    	$("#entry_settIns").prop("checked",true);
	    
	    if(result.list1.configSettBs==1)
            $("#entry_settHs").prop("checked",true);
	    
	    if(result.list1.configSettAs==1)
            $("#entry_settAs").prop("checked",true);
	    
	    if(result.list1.configBsWeek==0)
            $("#entry_srvBsWeek0").prop("checked",true);
	    
	    if(result.list1.configBsWeek==1)
            $("#entry_srvBsWeek1").prop("checked",true);
	    
	    if(result.list1.configBsWeek==2)
            $("#entry_srvBsWeek2").prop("checked",true);
	    
	    if(result.list1.configBsWeek==3)
            $("#entry_srvBsWeek3").prop("checked",true);
	    
	    if(result.list1.configBsWeek==4)
            $("#entry_srvBsWeek4").prop("checked",true);
	    
	    doGetCombo('/services/bs/getHSCody.do?&SRV_SO_ID='+'${result.list1.ordNo}', '', '','entry_cmbServiceMem', 'S' , '');    
        fn_getHSConfigBasicInfo();
	    
	}
</script>

<section id="content"><!-- content start -->
<ul class="path">
    <!-- <li><img src="../images/common/path_home.gif" alt="Home" /></li> -->
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>HS Result Reverse</h2>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="searchForm" id="searchForm" method="post">
    <input type="hidden"  id="salesOrdId" name="salesOrdId"/>
    
    
    <aside class="link_btns_wrap">
    <div id="divErrorMessage" style="width: 100%; height: 20px; margin: 0 auto;">
        <span style="color: #CC0000" ID="lblErrorMessage"></span>
    </div>
    </aside><!-- grid_wrap end -->
    
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:100px" />
    <col style="width:*" />
</colgroup>
<tbody>

<tr>
    <th scope="row"><spring:message code='svc.hs.reversal.hsNumber'/></th>
    <td><input type="text" title="" id="hsNo" name="hsNo" placeholder="" class="" />
        <!-- <a href="javascript:fn_orderSearch();" class="search_btn"><img src="../images/common/normal_search.gif" alt="search" /></a> -->
        <p class="btn_grid"><a href="javascript:fn_orderSearch();"><span class="search"></span><spring:message code='sys.btn.search'/></span></a></p>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_wrap_memList" style="width: 100%; height: 60px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->
<aside class="title_line"><!-- title_line start -->
    <span></span>
</aside><!-- title_line end -->
</form>
</section><!-- search_table end -->

<aside class="link_btns_wrap">
    <div  style="width: 100%; height: 20px;text-align:right;color:darkblue;">
        Only the latest installation result will display.
    </div>
</aside><!-- grid_wrap end -->
    
<aside class="title_line"><!-- title_line start -->
<h3><spring:message code='svc.hs.reversal.viewDetail'/></h3>
</aside><!-- title_line end -->

<form id="frmBasicInfo" method="post">
        <%-- <input id="salesOrderId" name="salesOrderId" type="hidden" value="${basicInfo.ordId}"/> --%>
        <input type="hidden" name="salesOrderId"  id="salesOrderId"/>  
        <input type="hidden" name="configId"  id="configId"/>
        <input type="hidden" name="brnchId"  id="brnchId"/>
        <input type="hidden" name="hscodyId"  id="hscodyId"/>
        <input type="hidden" name="configBsRem"  id="configBsRem"/>
        
        <table class="type1"><!-- table start -->
        <caption>table</caption>
        <colgroup>
            <col style="width:150px" />
            <col style="width:*" />
            <col style="width:150px" />
            <col style="width:*" />
        </colgroup>
        <tbody>
        <tr>
            <th scope="row" ><spring:message code='svc.hs.reversal.orderNo'/></th>
           <%--  <td><span><c:out value="${basicInfo.ordNo}"/></span> --%>
            <td>
            <input type="text" title="" id="entry_orderNo" name="entry_orderNo"  placeholder="" class="readonly " readonly="readonly" style="width: 188px; " />
            </td>
            <th scope="row"><spring:message code='svc.hs.reversal.applicationType'/></th>
            <td>
            <input type="text" title="" id="entry_appType" name="entry_appType" placeholder="" class="readonly " readonly="readonly" style="width: 157px; "/>
            </td>
        </tr>
        <tr>
            <th scope="row"><spring:message code='svc.hs.reversal.installationAddress'/></th>
            <td colspan="3">
            <input type="text" title="" id="entry_address" name="entry_address" placeholder="" class="readonly " readonly="readonly" style="width: 188px; "/>
            </td>
        </tr>
        <tr>
            <th scope="row"><spring:message code='svc.hs.reversal.product'/></th>
            <td>
            <input type="text" title="" id="entry_product" name="entry_product" placeholder="" class="readonly " readonly="readonly" style="width: 188px; "/>
            </td>
            <th scope="row"><spring:message code='svc.hs.reversal.customerName'/></th>
            <td>
            <input type="text" title="" id="entry_custName" name="entry_custName" placeholder="" class="readonly " readonly="readonly" style="width: 157px; "/>    
            </td>
        </tr>
        <tr>
            <th scope="row"><spring:message code='svc.hs.reversal.nricComNo'/></th>
            <td>
            <input type="text" title="" id="entry_nric" name="entry_nric"  placeholder="" class="readonly " readonly="readonly" style="width: 188px; "/>
            </td>
            <th scope="row"><spring:message code='svc.hs.reversal.hsAvailability'/></th>
            <td>
        <%--    <input type="text" title="" id="entry_availability" name="entry_availability"  value="${BasicInfo.custNric}" placeholder="" class="readonly " readonly="readonly" style="width: 464px; "/> --%>
            <select class="w100p" id="entry_availability" name="entry_availability">
                <option value="1">Available</option>
                <option value="0">Unavailable</option>
            </select>
            
            </td>
        </tr>
        <tr>
            <th scope="row"><spring:message code='svc.hs.reversal.hsCodyCode'/></th>
            <td>
            <select class="w100p"  id="entry_cmbServiceMem" name="entry_cmbServiceMem" >
            </select>
            </td>
            <th scope="row"><spring:message code='svc.hs.reversal.lastHsDate'/></th>
            <td>
            <input type="text" id="entry_lstHSDate" name="entry_lstHSDate" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" />
            </td>
        </tr>
        <tr>
            <th scope="row"><spring:message code='svc.hs.reversal.remark'/></th>
            <td colspan="3">
             <textarea cols="20" rows="5" id="entry_remark" name="entry_remark" placeholder="" > </textarea> 
        </tr>
        <tr>
            <th scope="row"><spring:message code='svc.hs.reversal.happyCallService'/></th>
            <td colspan="3">
            <label><input type="checkbox" id="entry_settIns" name="entry_settIns"  /><span><spring:message code='svc.hs.reversal.installationType'/></span></label>
            <label><input type="checkbox" id="entry_settHs" name="entry_settHs" /><span><spring:message code='svc.hs.reversal.bsType'/></span></label>
            <label><input type="checkbox" id="entry_settAs" name="entry_settAs" /><span><spring:message code='svc.hs.reversal.asType'/></span></span></label>
            </td>
        </tr>
        <tr>
            <th scope="row"><spring:message code='svc.hs.reversal.preferHsWeek'/></th>
            <td colspan="3">
            <label><input type="radio" id="entry_srvBsWeek0" name="entry_srvBsWeek" value="0"/><span><spring:message code='svc.hs.reversal.none'/></span></label>
            <label><input type="radio" id="entry_srvBsWeek1" name="entry_srvBsWeek" value="1" /><span><spring:message code='svc.hs.reversal.week1'/></span></label>
            <label><input type="radio" id="entry_srvBsWeek2" name="entry_srvBsWeek" value="2" /><span><spring:message code='svc.hs.reversal.week2'/></span></label>
            <label><input type="radio" id="entry_srvBsWeek3" name="entry_srvBsWeek" value="3" /><span><spring:message code='svc.hs.reversal.week3'/></span></label>
            <label><input type="radio" id="entry_srvBsWeek4" name="entry_srvBsWeek" value="4" /><span><spring:message code='svc.hs.reversal.week4'/></span></label>
            </td>
        </tr>
        </tbody>
        </table><!-- table end -->
        <!-- 
        <ul class="center_btns">
            <li><p class="btn_blue2 big"><a href="#" onclick="fn_doSave()">SAVE</a></p></li>
        </ul>
         -->
    </form>

<div id="divResultReversal">
<aside class="title_line"><!-- title_line start -->
<h3>HS Result Reversal</h3>
</aside><!-- title_line end -->
<form action="" id="editForm" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
    <col style="width:190px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code='svc.hs.reversal.resversalStatus'/></th>
    <td><span id="lblShowRevInstallStatus1" style="font-weight:bold;"><spring:message code='svc.hs.reversal.from'/></span>
    <span id="lblShowRevInstallStatus2" style="text-decoration: underline; font-weight:bold; color:brown; font-Style:italic"><spring:message code='svc.hs.reversal.complete'/></span>
    <span id="lblShowRevInstallStatus3" style="font-weight:bold;"><spring:message code='svc.hs.reversal.to'/></span></span>
    <span id="lblShowRevInstallStatus4" style="text-decoration: underline; font-weight:bold; color:brown; font-Style:italic"><spring:message code='svc.hs.reversal.fail'/></span>
    </td>
    <th scope="row"><spring:message code='svc.hs.reversal.inchargeCody'/></span></th>
    <td><span id="lblCT"></span></td>
    <th scope="row"><spring:message code='svc.hs.reversal.completeDate'/></th>
    <td>
        <div class="date_set w100p"><!-- date_set start -->
        <p><input type="text" title="Install Date" placeholder="DD/MM/YYYY" class="j_date" id="instalStrlDate" name="instalStrlDate"/></p>
        </div>
    </td>
    
</tr>
<tr>
    <th scope="row"><spring:message code='svc.hs.reversal.reverseReason'/></th>
    <td>
        <select class="w100p" id="reverseReason" name="reverseReason">
        <option value="" selected>Reverse Reason</option>
         <c:forEach var="list" items="${selectReverseReason }" varStatus="status">
           <option value="${list.resnId}">${list.code} - ${list.resnDesc}</option>
        </c:forEach>
        </select>
    </td>
    <th scope="row"><spring:message code='svc.hs.reversal.failReason'/></th>
    <td>
        <select class="w100p" id="failReason" name="failReason">
        <option value="" selected>Fail Reason</option>
         <c:forEach var="list" items="${selectFailReason }" varStatus="status">
           <option value="${list.resnId}">${list.code} - ${list.resnDesc}</option>
        </c:forEach>
        </select>
    </td>
    <th scope="row"><spring:message code='svc.hs.reversal.nextCallDate'/></th>
    <td>
        <div class="date_set w100p"><!-- date_set start -->
        <p><input type="text" title="Next Call Date" placeholder="DD/MM/YYYY" class="j_date" id="nextCallStrlDate" name="nextCallStrlDate"/></p>
        </div>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='svc.hs.reversal.reverseReasonRemark'/></th>
    <td colspan="5">
        <textarea cols="20" rows="5" id="reverseReasonText" name="reverseReasonText"></textarea>
    </span></td>
</tr>
</tbody>
</table>
<ul class="center_btns">
    <li><p class="btn_blue2 big" id="btnReverse"><a href="#" onclick="javascript:fn_save()"><spring:message code='svc.hs.reversal.confirmToReverse'/></a></p></li>
</ul>
</form>
</div>
</section><!-- content end -->