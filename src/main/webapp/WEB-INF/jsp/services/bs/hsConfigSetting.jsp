<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


    <script type="text/javaScript" language="javascript">

        var StatusTypeData = [{"codeId": "1","codeName": "Active"},{"codeId": "4","codeName": "Completed"},{"codeId": "21","codeName": "Failed"},{"codeId": "10","codeName": "Cancelled"}];
       var gradioVal = $("input:radio[name='searchDivCd']:checked").val();

        // AUIGrid 생성 후 반환 ID
        var myGridID;

        var option = {
		        width : "1200px",   // 창 가로 크기
		        height : "600px"    // 창 세로 크기
            };

        function basicManagementGrid(){
                // AUIGrid 칼럼 설정
		       var columnManualLayout = [/* {
		                            dataField:"rnum",
		                            headerText:"RowNum",
		                            width:120,
		                            height:30
		                            ,
		                            visible:false
		                              },*/ {
		                            dataField : "custId",
		                            //headerText : "Customer",
		                            headerText : '<spring:message code="service.grid.Customer" />',
		                            width : 120
		                        }, {
		                            dataField : "name",
		                            //headerText : "Customer Name",
		                            headerText : '<spring:message code="service.grid.CustomerName" />',
		                            width : 120
		                       }, {
		                            dataField : "salesOrdNo",
		                            //headerText : "Sales Order",
		                            headerText : '<spring:message code="service.grid.SalesOrder" />',
		                            width : 120
		                        }, /*{
		                            dataField : "hsDate",
		                            headerText : "HS Date",
		                            width : 120 ,
		                            visible:false
		                        }, {
		                            dataField : "no",
		                            headerText : "HS Order",
		                            width : 120,
                                    visible:false
		                        }, {
		                            dataField : "c5",
		                            headerText : "Assign Cody",
		                            width : 120,
                                    visible:false
		                        }, {
		                            dataField : "code",
		                            headerText : "Cody Status",
		                            width : 120,
                                    visible:false
		                        }, {
		                            dataField : "code1",
		                            headerText : "HS Status",
		                            width : 120,
                                    visible:false
		                        }, {
		                            dataField : "month",
		                            headerText : "Complete Cody",
		                            width : 120                             ,
		                            visible:false
		                        }, {
		                            dataField : "brnchId",
		                            headerText : "Branch",
		                            width : 120
		                             ,
		                            visible:false
		                        }, {
		                            dataField : "schdulId",
		                            headerText : "schdulId",
		                            width : 120                                 ,
		                            visible:false
		                               ,
		                            visible:false
		                        }, {
		                            dataField : "salesOrdId",
		                            headerText : "salesOrdId",
		                            width : 120,
                                    visible:false
                                        },*/ {
                                    dataField : "codyMangrUserId",
                                    //headerText : "Cody Manager",
                                    headerText : '<spring:message code="service.grid.CodyManager" />',
                                    width : 120
		                              }, {
		                            dataField : "codyBrnchCode",
		                            //headerText : "Branch Code",
		                            headerText : '<spring:message code="service.grid.BranchCode" />',
		                            width : 120
		                    }];

		             // 그리드 속성 설정
	                 var gridPros = {
	                    // 페이징 사용
	                    usePaging : true,
	                    // 한 화면에 출력되는 행 개수 20(기본값:20)
	                    pageRowCount : 20,

	                    editable : false,

	                    //showStateColumn : true,

	                    displayTreeOpen : true,

	                    headerHeight : 30,

	                    // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
	                    skipReadonlyColumns : true,

	                    // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
	                    wrapSelectionMove : true,

	                    // 줄번호 칼럼 렌더러 출력
	                    showRowNumColumn : true
	                };
                            //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
                        myGridID = AUIGrid.create("#grid_wrap", columnManualLayout, gridPros);
            }

        $(document).ready(function() {

            $('#ManuaMyBSMonth').val($.datepicker.formatDate('mm/yy', new Date()));
		    // AUIGrid 그리드를 생성합니다.
		    basicManagementGrid();

		    AUIGrid.setSelectionMode(myGridID, "singleRow");

	        // 셀 더블클릭 이벤트 바인딩
/* 	        AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
	           salesOrdId = AUIGrid.getCellValue(myGridID, event.rowIndex, "salesOrdId");
	//                var param = "?ord_Id="+salesOrdId+"&ord_No="+salesOrdNo+"&as_No="+asNo+"&as_Id="+asid;
	           Common.popupDiv("/bs/hsConfigBasicPop.do?&salesOrdId="+salesOrdId, null, null , true , '_ConfigBasicPop');
	        });    */


 	            AUIGrid.bind(myGridID, "cellClick", function(event) {
			      salesOrdId =  AUIGrid.getCellValue(myGridID, event.rowIndex, "salesOrdId");
			      brnchId =  AUIGrid.getCellValue(myGridID, event.rowIndex, "brnchId");
			      codyMangrUserId =  AUIGrid.getCellValue(myGridID, event.rowIndex, "codyMangrUserId");
			      custId = AUIGrid.getCellValue(myGridID, event.rowIndex, "custId");
			  });


                $('#exchgBodyAmbientAssy').click(function() {
                    Common.popupDiv("/services/bs/hsExchgBodyAmbientAssyPop.do", null, null, true);
                });

		});


         // 리스트 조회.
        function fn_getBasicListAjax() {
	            Common.ajax("GET", "/services/bs/selectHsBasicList.do", $("#searchForm").serialize(), function(result) {
	                console.log("성공.");
	                console.log("data : " + result);
	                AUIGrid.setGridData(myGridID, result);
	            });
        }


        function fn_basicInfo() {

            var selectedItems = AUIGrid.getSelectedItems(myGridID);
            if(selectedItems.length  <= 0) {
		        //Common.alert("<b>No HS selected.</b>");
		        Common.alert("<b><spring:message code='service.msg.NoHSData'/><b> ");
		        return ;
		    }



               Common.popupDiv("/services/bs/hsConfigBasicPop.do?&salesOrdId="+salesOrdId +"&brnchId="+brnchId +"&codyMangrUserId="+codyMangrUserId+"&custId="+custId, null, null , true , '_ConfigBasicPop');

        }

        function fn_filterSetInfo() {

            var selectedItems = AUIGrid.getSelectedItems(myGridID);
            if(selectedItems.length  <= 0) {
                //Common.alert("<b>No HS selected.</b>");
                Common.alert("<b><spring:message code='service.msg.NoHSData'/><b> ");
                return ;
            }

            var userDefine26 =  '${PAGE_AUTH.funcUserDefine26}';

               Common.popupDiv("/services/bs/hSFilterSettingPop.do?&salesOrdId="+salesOrdId+"&userDefine26="+userDefine26, null, null , true , '_FilterSetPop');
        }

        function fn_fmcoEvoucher() {

        	Common.popupDiv("/services/bs/report/hsFmcoEvoucherPop.do", null, null, true, '');
        }

    </script>






<form action="#" id="searchForm" name="searchForm">

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2><spring:message code='service.title.HSManagement'/></h2>
<ul class="right_btns">
<c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_getBasicListAjax();"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
</c:if>
</ul>
<!--조회조건 추가  -->
<!--     <label><input type="radio" name="searchDivCd" value="1" onClick="fn_checkRadioButton('comm_stat_flag')" checked />HS Order Search</label>
    <label><input type="radio" name="searchDivCd" value="2" onClick="fn_checkRadioButton('comm_stat_flag')" />Manual HS</label> -->
</aside><!-- title_line end -->


<div id="hsManagement" style="display:block;">

</div>



<div id="hsManua" style="display:block;">
            <section class="search_table"><!-- search_table start -->
            <table class="type1"><!-- table start -->
            <caption>table</caption>
            <colgroup>
                <col style="width:100px" />
                <col style="width:*" />
                <col style="width:100px" />
                <col style="width:*" />
            </colgroup>
            <tbody>
            <tr>
                <th scope="row"><spring:message code='service.title.SalesOrder'/></th>
                <td>
                    <input id="ManuaSalesOrder" name="ManuaSalesOrder"  type="text" title="" placeholder="Sales Order" class="w100p" />
                </td>
<!--                 <th scope="row">HS Period</th>
                <td>
                    <input id="ManuaMyBSMonth" name="ManuaMyBSMonth" type="text" title="기준년월" placeholder="MM/YYYY" class="j_date2 w100p" readonly />
                </td> -->
                <th scope="row"><spring:message code='service.title.Customer'/></th>
                <td>
                    <input id="manualCustomer" name="manualCustomer"  type="text" title="" placeholder="Customer" class="w100p" />
                </td>

            </tr>
            </tbody>
            </table><!-- table end -->

            <aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<%--             <p class="show_btn"><a href="#"><br><br><br><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p> --%>
            <%-- <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p> --%>
            <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
            <dl class="link_list">
                <dt>Link</dt>
                <dd>
                <ul class="btns">
                 <c:if test="${PAGE_AUTH.funcUserDefine4 == 'Y'}">
                    <li><p class="link_btn"> <a href="javascript:fn_basicInfo()" id="basicInfo">HS Basic Info</a> </p></li>
                        <li><p class="link_btn"> <a href="javascript:fn_exchgBodyAmbientAssy()" id="exchgBodyAmbientAssy">Exchange Body Ambient Assy Report</a> </p></li>
                </c:if>
                <c:if test="${PAGE_AUTH.funcUserDefine5 == 'Y'}">
                <li><p class="link_btn"><a href="javascript:fn_filterSetInfo()" id="filterSet">HS Filter Maintenance</a></p></li>
                </c:if>

                <!-- e-Voucher 2.0 - FMCO start -->
                <c:if test="${PAGE_AUTH.funcUserDefine8 == 'Y'}">
                    <li><p class="link_btn"> <a href="javascript:fn_fmcoEvoucher()" id="basicInfo">FMCCO E-VOUCHER</a> </p></li>
                </c:if>
                <!-- e-Voucher 2.0 - FMCO end -->

                </ul>
                <ul class="btns">
                </ul>
                <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
                </dd>
            </dl>
            </aside><!-- link_btns_wrap end -->

            </section><!-- search_table end -->

</div>
    <ul class="right_btns">


    </ul>

<section class="search_result"><!-- search_result start -->

<!-- <ul class="right_btns">
    <li><p class="btn_grid"><a id="hSConfiguration">HS Order Create</a></p></li>
</ul> -->
<!-- <ul class="right_btns">
    <li><p class="btn_grid"><a href="#" " onclick="javascript:fn_getHSConfAjax();">HS Configuration</a></p></li>
</ul> -->
<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap" style="width: 100%; height: 500px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

<ul class="center_btns">
<!--     <li><p class="btn_blue2"><a href="#">Cody Assign</a></p></li> -->
</ul>

</section><!-- content end -->
</form>