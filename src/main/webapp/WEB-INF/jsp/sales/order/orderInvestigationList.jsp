<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
    //AUIGrid 생성 후 반환 ID
    var myGridID;
    
    $(document).ready(function(){
        
        // AUIGrid 그리드를 생성합니다.
        createAUIGrid();
        
//        AUIGrid.setSelectionMode(myGridID, "singleRow");
        
        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(myGridID, "cellDoubleClick", function(event){
        	$("#invReqId").val(event.item.invReqId);
        	Common.popupDiv("/sales/order/orderInvestInfoPop.do", $("#popForm").serializeJSON(), null, true, 'dtPop');
        });
        // 셀 클릭 이벤트 바인딩
    
    });
    
    function createAUIGrid() {
        var columnLayout = [ {
            dataField : "invReqNo",
            headerText : "Request No",
            width : 140,
            editable : false
        }, {
            dataField : "invReqPartyName",
            headerText : "Request Party",
            width : 160,
            editable : false
        }, {
            dataField : "invReqStusName",
            headerText : "Request Status",
            width : 170,
            editable : false
        }, {
            dataField : "salesOrdNo",
            headerText : "Order No.",
            editable : false
        }, {
            dataField : "invReqCrtUserName",
            headerText : "Request By",
            editable : false
        }, {
            dataField : "invReqUpdDt",
            headerText : "Request At",
            width : 170,
            editable : false
        }, {
            dataField : "invReqId",
            visible : false
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
            useGroupingPanel : true,
            
            // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            skipReadonlyColumns : true,
            
            // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            wrapSelectionMove : true,
            
            // 줄번호 칼럼 렌더러 출력
            showRowNumColumn : true,
            
            groupingMessage : "Here groupping"
        };
    
    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
    myGridID = GridCommon.createAUIGrid("#list_grid_wrap", columnLayout,'', gridPros);
    }
    
    // 리스트 조회.
    function fn_orderInvestigationListAjax() {        
        Common.ajax("GET", "/sales/order/orderInvestJsonList", $("#searchForm").serialize(), function(result) {
            AUIGrid.setGridData(myGridID, result);
        }
        );
    }
    
    function fn_clear(){
        $("#invReqNo").val('');
        $("#startCrtDt").val('');
        $("#endCrtDt").val('');
        $("#salesOrdNo").val('');
        $("#invReqCrtUserName").val('');
        $(".multy_select").prop("checked", false);
        $("#invReqPartyId").val('');
    }
    
    function fn_goSingle(){
    	$("#searchForm").attr({"target": "_self" , "action" : getContextPath()+"/sales/order/orderNewRequestSingleList.do" }).submit();
    }
    
    function fn_goBatch(){
        Common.alert('The program is under development.');
    }
</script>
<form id="popForm" method="post">
    <input type="hidden" name="invReqId"  id="invReqId"/> 
</form>
<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Order Investigation Request Search - Officer</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" onClick="fn_goSingle()">New Request(Single)</a></p></li>
    <li><p class="btn_blue"><a href="#" onClick="fn_goBatch()">New Request(Batch)</a></p></li> 
    <li><p class="btn_blue"><a href="#" onClick="fn_orderInvestigationListAjax()"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a href="#" onClick="fn_clear()"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="searchForm" name="searchForm" action="#" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
    <tbody>
        <tr>
            <th scope="row">Request No</th>
            <td>
              <input type="text" id="invReqNo" name="invReqNo" title="" placeholder="" class="w100p" />
            </td>
            <th scope="row">Request Date</th>
            <td>
            <div class="date_set w100p"><!-- date_set start -->
                <p><input type="text" id="startCrtDt" name="startCrtDt" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                <span>To</span>
                <p><input type="text" id="endCrtDt" name="endCrtDt" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
            </div><!-- date_set end -->
            </td>
            <th scope="row">Order No</th>
            <td>
              <input type="text" title="" id="salesOrdNo" name="salesOrdNo" placeholder="" class="w100p" />
            </td>
        </tr>
        <tr>
            <th scope="row">Request User</th>
            <td>
              <input type="text" title="" id="invReqCrtUserName" name="invReqCrtUserName" placeholder="" class="w100p" />
            </td>
            <th scope="row">Request Status</th>
            <td>
                <select class="multy_select w100p" id="invReqStusId" name="invReqStusId" multiple="multiple">
                    <option value="1">Active</option>
                    <option value="44">Pending</option>
                    <option value="5">Approved</option>
                    <option value="6">Rejected</option>
                </select>
            </td>
            <th scope="row">Request Party</th>
            <td>
                <select class="w100p" id="invReqPartyId" name="invReqPartyId">
                    <option value="">Request Party</option>
                    <option value="770">Web User</option>
                    <option value="771">Cody User</option>
                </select>
            </td>
        </tr>
    </tbody>
</table><!-- table end -->
</form>

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt>Link</dt>
    <dd>
    <ul class="btns">
        <li><p class="link_btn type2"><a href="#">Request Raw Data</a></p></li>
    </ul>
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end -->

</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<!-- title_line start 
<aside class="title_line">
<h3>Request Raw Data</h3>
</aside>!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="list_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->
        
<hr />
