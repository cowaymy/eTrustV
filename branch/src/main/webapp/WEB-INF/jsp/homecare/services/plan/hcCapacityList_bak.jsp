<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">
    // AUIGrid 생성 후 반환 ID
    var myGridID;
    var cnt = 0;

    function createAUIGrid(){
        // AUIGrid 칼럼 설정
		var columnLayout = [ {dataField : "promoId", headerText : "Branch", width : 120}];
	    // AUIGrid 칼럼 설정
		var columnLayout =
		    [
                {dataField : "brnchId", headerText : "Branch", width: 280},
                {headerText : "Morning", children : [
			        {dataField: "morngSesionAs",    headerText: "AS",        width:60},
			        {dataField: "morngSesionIns",    headerText: "INS",      width:60},
			        {dataField: "morngSesionRtn",   headerText: "RTN",     width:60}
		        ]},
		        {headerText : "Afternoon", children : [
	                {dataField: "aftnonSesionAs",     headerText: "AS",       width:60},
	                {dataField: "aftnonSesionIns",    headerText: "INS",      width:60},
	                {dataField: "aftnonSesionIns",    headerText: "RTN",     width:60}
	            ]},
	            {headerText : "Evening", children : [
                    {dataField: "evngSesionAs",       headerText: "AS",       width:60},
                    {dataField: "evngSesionIns",      headerText: "INS",      width:60},
                    {dataField: "evngSesionRtn",     headerText: "RTN",      width:60}
                ]}
	        ];

		// 그리드 속성 설정
		var gridPros = {
			// 페이징 사용
		    usePaging : true,
		    // 한 화면에 출력되는 행 개수 20(기본값:20)
		    pageRowCount : 20,
		    editable : true,
		    showStateColumn : true,
		    displayTreeOpen : true,
		    headerHeight : 30,
		    // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
		    skipReadonlyColumns : true,
		    // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
		    wrapSelectionMove : true,
		    // 줄번호 칼럼 렌더러 출력
		    showRowNumColumn : true,
		};

		myGridID = AUIGrid.create("#grid_wrap", columnLayout, gridPros);
    }

    // 행 추가 이벤트 핸들러
    function auiAddRowHandler(event) {

    }



    // 행 추가, 삽입
    function addRow() {
        var item = new Object();
        AUIGrid.addRow(myGridID, item, "first");
    }

    // 화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
    $(document).ready(function(){
        // AUIGrid 그리드를 생성합니다.
        createAUIGrid();
        AUIGrid.setSelectionMode(myGridID, "singleRow");

        // 행 추가 이벤트 바인딩
        AUIGrid.bind(myGridID, "addRow", auiAddRowHandler);
    });

    //서버로 전송.
    function fn_saveSsCapacityBrList(){
        // to-do 체크로직 추가해야 함
        Common.ajax("POST", "/sample/saveSsCapacityBrList.do", GridCommon.getEditData(myGridID), function(result) {
            alert("성공");
            resetUpdatedItems(); // 초기화
            console.log("성공.");
            console.log("data : " + result);
        }, function(jqXHR, textStatus, errorThrown) {
            try {
            } catch (e) {
                console.log(e);
	        }
            alert("Fail : " + jqXHR.responseJSON.message);
            fn_getSsCapacityBrListAjax();
        });
    }

    function resetUpdatedItems() {
        // 모두 초기화.
        AUIGrid.resetUpdatedItems(myGridID, "a");
    }

    // 리스트 조회.
    function fn_getSsCapacityBrListAjax() {
        Common.ajax("GET", "/organization/selectSsCapacityBrList", $("#searchForm").serialize(), function(result) {
            AUIGrid.setGridData(myGridID, result);
        });
    }

</script>

<section id="content"><!-- content start -->
	<ul class="path">
	    <li><img src="../images/common/path_home.gif" alt="Home" /></li>
	    <li>Sales</li>
	    <li>Order list</li>
	</ul>

	<!-- title_line start -->
	<aside class="title_line">
		<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
		<h2>Session Capacity</h2>
	</aside>
	<!-- title_line end -->

	<!-- search_table start -->
	<section class="search_table">
	<form action="#" method="post">
		<!-- title_line start -->
		<aside class="title_line">
		<h3>Organization Information Display</h3>
		<ul class="right_btns">
		    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_getSsCapacityBrListAjax();"><span class="search"></span>Search</a></p></li>
		    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_saveSsCapacityBrList();"><span class="save"></span>Save</a></p></li>
		</ul>
		</aside>
		<!-- title_line end -->
		<!-- table start -->
		<table class="type1">
			<caption>table</caption>
			<colgroup>
			    <col style="width:200px" />
			    <col style="width:*" />
			    <col style="width:170px" />
			    <col style="width:*" />
			</colgroup>
			<tbody>
				<tr>
				    <th scope="row">Branch</th>
				    <td>
	                    <select id="cmbbranchId" name="cmbbranchId" class="multy_select w100p" multiple="multiple">
				        <c:forEach var="list" items="${dscBranchList }">
				            <option value="${list.brnchId }">${list.brnchName }</option>
				         </c:forEach>
				         </select>
				    </td>
				    <th scope="row">Branch Description</th>
				    <td><input type="text" title="" placeholder="" class="" /></td>
				</tr>
				<tr>
				    <th scope="row">CTM Code</th>
				    <td><input type="text" title="" placeholder="" class="" /></td>
				    <th scope="row">CTM Name</th>
				    <td><input type="text" title="" placeholder="" class="" /></td>
				</tr>
				<tr>
				    <th scope="row">Configuration Category</th>
				    <td colspan="3"><input type="text" title="" placeholder="" class="" /></td>
				</tr>
			</tbody>
		</table>
		<!-- table end -->
		<!-- link_btns_wrap start -->
		<aside class="link_btns_wrap">
            <p class="show_btn"><a href="#"><img src="../images/common/btn_link.gif" alt="link show" /></a></p>
			<dl class="link_list">
			    <dt>Link</dt>
			    <dd>
				    <ul class="btns">
				        <li><p class="link_btn"><a href="#">menu1</a></p></li>
				        <li><p class="link_btn"><a href="#">menu2</a></p></li>
				        <li><p class="link_btn"><a href="#">menu3</a></p></li>
				        <li><p class="link_btn"><a href="#">menu4</a></p></li>
				        <li><p class="link_btn"><a href="#">Search Payment</a></p></li>
				        <li><p class="link_btn"><a href="#">menu6</a></p></li>
				        <li><p class="link_btn"><a href="#">menu7</a></p></li>
				        <li><p class="link_btn"><a href="#">menu8</a></p></li>
				    </ul>
				    <ul class="btns">
				        <li><p class="link_btn type2"><a href="#">menu1</a></p></li>
				        <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
				        <li><p class="link_btn type2"><a href="#">menu3</a></p></li>
				        <li><p class="link_btn type2"><a href="#">menu4</a></p></li>
				        <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
				        <li><p class="link_btn type2"><a href="#">menu6</a></p></li>
				        <li><p class="link_btn type2"><a href="#">menu7</a></p></li>
				        <li><p class="link_btn type2"><a href="#">menu8</a></p></li>
				    </ul>
				    <p class="hide_btn"><a href="#"><img src="../images/common/btn_link_close.gif" alt="hide" /></a></p>
			    </dd>
			</dl>
		</aside>
        <!-- link_btns_wrap end -->
	</form>
	</section>
    <!-- search_table end -->

	<!-- search_result start -->
	<section class="search_result">
        <!-- title_line start -->
		<aside class="title_line">
		<h3>Branch Capacity Configuration </h3>
		<ul class="right_btns">
		    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
		    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
		    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
		    <li><p class="btn_grid"><a href="#">INS</a></p></li>
		    <li><p class="btn_grid" onclick="addRow()"> <a href="#">ADD</a></p></li>
		</ul>
		</aside>
        <!-- title_line end -->
		<article class="grid_wrap"><!-- grid_wrap start -->
		      <div id="grid_wrap" style="width: 100%; height: 334px; margin: 0 auto;"></div>
		<!-- 그리드 영역  -->
		</article>
        <!-- grid_wrap end -->
	</section>
    <!-- search_result end -->
</section>
<!-- content end -->

<aside class="bottom_msg_box"><!-- bottom_msg_box start -->
<p>Information Message Area</p>
</aside><!-- bottom_msg_box end -->
