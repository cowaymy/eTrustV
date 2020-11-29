<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">
    //AUIGrid 생성 후 반환 ID
    var myGridID;

    var categoryCdList = [];
    <c:forEach var="obj" items="${categoryCdList}">
    categoryCdList.push({codeId:"${obj.code}", codeName:"${obj.codeName}", code:"${obj.code}"});
    </c:forEach>

    $(document).ready(function(){

    	// AUIGrid 그리드를 생성합니다.
        createAUIGrid();

        doDefCombo(categoryCdList, '', 'cmbRentalStus', 'M', 'f_multiCombo');   //Rental Status

    });

    function createAUIGrid() {
        // AUIGrid 칼럼 설정

        // 데이터 형태는 다음과 같은 형태임,
        //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
    	var columnLayout = [{
    		dataField : "salesOrdNo",
    		headerText : "Order No.",
    		width : 130,
    		editable : false,
    		style : 'left_style'
    	}, {
    		dataField : "custId",
    		headerText : "Cust ID",
    		width : 130,
    		editable : false,
    		style : 'left_style'
    	}, {
    		dataField : "name",
    		headerText : "Customer Name",
    		width : 130,
    		editable : false,
    		style : 'left_style'
    	}, {
    		dataField : "instlState",
    		headerText : "Installation State",
    		width : 130,
    		editable : false,
    		style : 'left_style'
    	}, {
    		dataField : "title",
    		headerText : "Title",
    		width : 130,
    		editable : false,
    		style : 'left_style'
    	}, {
    		dataField : "usedMth",
    		headerText : "Used Months",
    		width : 130,
    		editable : false,
    		style : 'left_style'
    	}, {
    		dataField : "hpCode",
    		headerText : "HP Code",
    		width : 130,
    		editable : false,
    		style : 'left_style'
    	}, {
    		dataField : "hpName",
    		headerText : "HP Name",
    		width : 130,
    		editable : false,
    		style : 'left_style'
    	}, {
    		dataField : "orgCode",
    		headerText : "Org Code",
    		width: 130,
    		editable : false,
    		style : 'left_style'
    	}, {
    		dataField : "grpCode",
    		headerText : "Group Code",
    		width : 130,
    		editable : false,
    		style : 'left_style'
    	}, {
    		dataField : "deptCode",
    		headerText : "Dept Code",
    		width : 130,
    		editable : false,
    		style : 'left_style'
    	}, {
    		dataField : "outstd",
    		headerText : "Outstanding Balance",
    		width : 130,
    		editable : false,
    		style : 'left_style'
    	}, {
    		dataField : "chsStus",
    		headerText : "CHS",
    		width : 130,
    		editable : false,
    		style : 'left_style'
    	}, {
    		dataField : "renStus",
    		headerText : "Rental Status",
    		width : 130,
    		editable : false,
    		style : 'left_style'
    	}];

    	// 그리드 속성 설정
    	var gridPros = {

    			// 페이징 사용
    			usePaging : true,
    			// 한 화면에 출력되는 행 개수 20(기본값:20)
    			pageRowCount : 20,
    			editable : true,
    			fixedColumnCount : 1,
    			showStateColumn : false,
    			displayTreeOpen : true,
    			selectionMode : "multipleCells",
    			headerHeight : 30,
    			// 그룹핑 패널 사용
    			useGroupingPanel : false,
    			// 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
    			skipReadonlyColumns : true,
    			// 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
    			wrapSelectionMove : true,
    			// 줄번호 칼럼 렌더러 출력
    			showRowNumColumn : false,
    			groupingMessage : "Here grouping"
    	};

    	myGridID = AUIGrid.create("#list_grid_wrap", columnLayout, gridPros);
    }

    function fn_getExpiredCustomerListAjax() {
        Common.ajax("GET", "/sales/customer/selectExpiredCustomerList", $("#expCustSearchForm").serialize(), function(result) {
        	AUIGrid.setGridData(myGridID, result);
        });
    }

    function f_multiCombo(){
         $('#cmbRentalStus').change(function() {

         }).multipleSelect({
            selectAll: true, //전체선택
            width: '80%'
         });
    }

    $(function(){
    	$('#btnSrch').click(function() {
    		if(fn_validSearchList()) fn_getExpiredCustomerListAjax();
    	});

    });

    function fn_validSearchList() {
    	var isValid = true, msg = "";

    	if(FormUtil.isEmpty($('#cmbExpMth').val())) {
    	    isValid = false;
            msg += '* <spring:message code="sal.alert.msg.selExpMth" /><br/>';
        }

    	if(FormUtil.isEmpty($('#cmbRentalStus').val())) {
    		isValid = false;
    	    msg += '* <spring:message code="sal.alert.msg.selRentalStus" /><br/>';
    	}

    	if(!isValid) Common.alert('<spring:message code="sal.title.text.expCustSrch" />' + DEFAULT_DELIMITER + "<b>" + msg + "</b>");

    	console.log("after" + isValid);
    	return isValid;

    }

    function fn_genExcel() {
    	var dd, mm, yy;

    	var today = new Date();
    	dd = today.getDay();
    	mm = today.getMonth();
    	yy = today.getFullYear();

    	GridCommon.exportTo("list_grid_wrap", 'xlsx', "EXPIRED_CUST_LISTING_" + yy + mm + dd);
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
            }
        });
    };
</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Customer</li>
</ul>

<aside class="title_line"><!-- title_line start -->
    <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
    <h2>Expired Individual Customer Listing</h2>
    <ul class="right_btns">
        <c:if test="${PAGE_AUTH.funcView == 'Y' }">
        <li><p class="btn_blue"><a href="#" id="btnSrch"><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li>
        </c:if>
        <li><p class="btn_blue"><a href="#" onclick="javascript:fn_genExcel();" id="genExcelBtn">Generate Excel</a></p></li>
        <li><p class="btn_blue"><a href="#" onclick="javascript:$('#expCustSearchForm').clearForm();"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p></li>
    </ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
    <form id="expCustSearchForm" name="expCustSearchForm" method="post">
        <table class="type1"><!-- table start -->
            <caption>table</caption>
            <colgroup>
                <col style="width:140px" />
                <col style=*" />
                <col style="width:130px" />
                <col style=*" />
                <col style="width:170px" />
                <col style=*" />
            </colgroup>
            <tbody>
                <tr>
                    <th scope="row"><spring:message code="sales.OrderNo" /></th>
                    <td>
                        <input type="text" title="Order No." id="salesOrdNo" name="salesOrdNo" placeholder="Sales Order Number" class="w100p" />
                    </td>
                    <th scope="row"><spring:message code="sales.custId2" /></th>
                    <td>
                        <input type="text" title="Customer ID" id="custId" name="custId" placeholder="Customer ID" class="w100p" />
                    </td>
                    <th scope="row"><spring:message code="sales.cusName" /></th>
                    <td>
                        <input type="text" title="Customer Name" id="name" name="name" placeholder="Customer Name" class="w100p" />
                    </td>
                </tr>
                <tr>
                    <th scope="row">Rental Status</th>
                    <td><select id="cmbRentalStus" name="rentStus" class="multy_select w100p" multiple="multiple"></select></td>
                    <th scope="row">Expired Months</th>
                    <td>
                        <select id="cmbExpMth" name="expMth" class="multy_select w100p" multiple="multiple">
                            <option value="4">4</option>
                            <option value="5">5</option>
                            <option value="6">6</option>
                            <option value="7">7</option>
                            <option value="8">8</option>
                            <option value="9">9</option>
                            <option value="10">10</option>
                        </select>
                    </td>
                    <th scope="row"></th>
                    <td></td>
                </tr>
            </tbody>
        </table><!-- table end -->

        <aside class="link_btns_wrap"><!-- link_btns_wrap start -->
            <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
            <dl class="link_list">
                <dt>Link</dt>
                <dd>
                <%-- <ul class="btns">
                        <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
                        <li><p class="link_btn type2"><a href="#" onclick="fn_rawData()"><spring:message code="sal.btn.conversionRawData" /></a></p></li>
                        </c:if>
                 </ul>  --%>
                 <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
                </dd>
            </dl>
        </aside><!-- link_btns_wrap end -->

    </form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->
    <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="list_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->
</section><!-- search_result end -->

</section><!-- content end -->