<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


    <script type="text/javaScript" language="javascript">

        // AUIGrid 생성 후 반환 ID
        var myGridID;

        var selectedGridValue;

        var option = {
                width : "1200px",   // 창 가로 크기
                height : "600px"    // 창 세로 크기
            };

        function basicManagementGrid(){
                // AUIGrid 칼럼 설정
               var columnManualLayout = [ {
					                dataField : "schdulID",
					                headerText : "Schedule ID",
					                width : 120,
					                visible : false
					            },{
					            	 dataField : "salesOrdId",
	                                    headerText : "Sales Order ID",
	                                    width : 120,
	                                    visible : false
                                },{
                                    dataField : "bsNo",
                                    headerText : "BS No",
                                    width : 100
                                },{
                                    dataField : "month",
                                    headerText : 'BS Month',
                                    width : 80
                               }, {
                                    dataField : "year",
                                    headerText : 'BS Year',
                                    width : 90
                                }, {
                                    dataField : "stusCode",
                                    headerText : 'BS Status',
                                    width : 80
                                },{
                                    dataField : "rsNo",
                                    headerText : 'Result No',
                                    width : 100
                                },{
                                    dataField : "salesOrdNo",
                                    headerText : 'Order No',
                                    width : 100
                                },{
                                    dataField : "code",
                                    headerText : 'App Type',
                                    width : 80
                                }, {
                                    dataField : "name",
                                    headerText : 'Customer Name',
                                    width : 300
                                }, {
                                    dataField : "memCode",
                                    headerText : 'Assign Member',
                                    width : 120
                                },  {
                                    dataField : "memCode2",
                                    headerText : 'Action Member',
                                    width : 120
                                },  {
                                    dataField : "instState",
                                    headerText : 'State',
                                    width : 160
                                },  {
                                    dataField : "instArea",
                                    headerText : 'Area',
                                    width : 160
                                }
                                ];

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

            $('#bsMonth').val($.datepicker.formatDate('mm/yy', new Date()));

            doGetCombo('/services/bs/selectStateList.do', '', '' ,'instState', 'S', '');
            doGetCombo('/services/bs/selectAreaList.do','', '' ,'instArea', 'S', '');

            AUIGrid.bind(myGridID, "cellClick", function( event ){
                selectedGridValue = event.rowIndex;
            });

            // AUIGrid 그리드를 생성합니다.
            basicManagementGrid();

                AUIGrid.bind(myGridID, "cellClick", function(event) {
                  schdulId =  AUIGrid.getCellValue(myGridID, event.rowIndex, "schdulId");
                  stusCode =  AUIGrid.getCellValue(myGridID, event.rowIndex, "stusCode");
                  salesOrdId =  AUIGrid.getCellValue(myGridID, event.rowIndex, "salesOrdId");
              });


        });


         // 리스트 조회.
        function fn_getBasicListAjax() {
        	 if ($("#instState").val() == '' || $("#instState").val() == null) {
                 Common.alert("Please Select 'Install State'");
                 return false;
             }

                Common.ajax("GET", "/services/bs/selectHsMnthlyMaintainOldList.do", $("#searchForm").serialize(), function(result) {
                    AUIGrid.setGridData(myGridID, result);
                });
        }

        function fn_BSSetting(){

        	var selectedItem = AUIGrid.getSelectedIndex(myGridID);
        	var day = new Date().getDate();

        	if (selectedItem[0] > -1){
        		if (stusCode == 'ACT'){
        			if(day < 13){
        			  Common.popupDiv("/services/bs/hsMnthlyMaintainOldPop.do?&schdulId="+schdulId+"&salesOrdId="+salesOrdId, null, null , true , '_ConfigBasicPop');
        			}else{
        				Common.alert("<b>Current month BS setting for this month has closed.</b>");
        			}
        		}else{
        			Common.alert("<b>[" + bsNo + "] already has [" + stusCode + "] result. BS setting adjustment is disallowed.</b>");
        		}
            }else{
                 Common.alert('No BS record found.');
            }
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
    </script>

<form action="#" id="searchForm" name="searchForm">

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Service</li>
    <li>Heart Service Execution</li>
    <li>HS Order Old version</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>HS Monthly Maintenance  (Old Version)</h2>
<ul class="right_btns">
<%-- <c:if test="${PAGE_AUTH.funcView == 'Y'}"> --%>
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_BSSetting();"></span><spring:message code='service.btn.BSCurrentMonthSetting'/></a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_getBasicListAjax();"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
<%-- </c:if> --%>
</ul>
<!--조회조건 추가  -->
<!--     <label><input type="radio" name="searchDivCd" value="1" onClick="fn_checkRadioButton('comm_stat_flag')" checked />HS Order Search</label>
    <label><input type="radio" name="searchDivCd" value="2" onClick="fn_checkRadioButton('comm_stat_flag')" />Manual HS</label> -->
</aside><!-- title_line end -->

<div id="hsManua" style="display:block;">
            <section class="search_table"><!-- search_table start -->
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
                <th scope="row">Order No</th>
                <td>
                    <input id="salesOrdNo" name="salesOrdNo" type="text" title="" placeholder="Order No" class="w100p" />
                </td>
                <th scope="row">BS Number</th>
                <td>
                    <input id="bsNo" name="bsNo" type="text" title="" placeholder="BS Number" class="w100p" />
                </td>
                <th scope="row">BS Month</th>
                <td>
                    <p><input id="bsMonth" name="bsMonth" type="text" title="기준년월" placeholder="MM/YYYY" class="j_date2 w100p"/></p>
                </td>
            </tr>
            <tr>
                <th scope="row">Result Number</th>
                <td>
                    <input id="rsNo" name="rsNo"  type="text" title="" placeholder="Result Number" class="w100p" />
                </td>
                <th scope="row">BS Status</th>
                <td>
				    <select class="multy_select w100p" multiple="multiple" id="bsStatus" name="bsStatus">
				    <option value="1"  selected>Active</option>
				    <option value="4">Completed</option>
				    <option value="21">Fail</option>
				    <option value="10">Cancelled</option>
				    </select>
			    </td>
                <th scope="row">Assigned Member</th>
                <td>
                    <input id="assignedMem" name="assignedMem"  type="text" title="" placeholder="Assigned Member" class="w100p" />
                </td>
            </tr>
            <tr>
                <th scope="row">Install State<span class="must">*</span></th>
                <td>
                    <select id="instState" name = "instState"></select>
                </td>
                <th scope="row">Install Area</th>
                <td>
                    <select id="instArea" name = "instArea"></select>
                </td>
                <th scope="row">Install Month</th>
                <td>
                    <input id="instMonth" name="instMonth" type="text" title="기준년월" placeholder="MM/YYYY" class="j_date2 w100p" readonly />
                </td>
            </tr>
            <tr>
                <th scope="row">Ineffective Cody</th>
                <td>
                     <input type="checkbox" id="ineffectiveCody" name="ineffectiveCody" />
                </td>
                <th scope="row">Action Member</th>
                <td>
                    <input id="actionMem" name="actionMem"  type="text" title="" placeholder="Action Member" class="w100p" />
                </td>
                <th scope="row"></th>
                <td>
                </td>
            </tr>
            </tbody>
            </table><!-- table end -->

           <!--aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<%--             <p class="show_btn"><a href="#"><br><br><br><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p> --%>
            <%-- <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p> --%>
            <!--p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
            <dl class="link_list">
                <dt>Link</dt>
                <dd>
                <ul class="btns">
                    <li><p class="link_btn"> <a href="javascript:fn_basicInfo()" id="basicInfo">HS Basic Info</a> </p></li>
                    <li><p class="link_btn"><a href="javascript:fn_filterSetInfo()" id="filterSet">HS Filter Maintenance</a></p></li>
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