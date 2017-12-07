<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
	// Make AUIGrid 
	var myGridID;
	
	//그리드 속성 설정
    var gridPros = {
        usePaging           : true,         //페이징 사용
        pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)            
        showStateColumn     : false,             
        displayTreeOpen     : false,            
        selectionMode       : "singleRow",  //"multipleCells",            
        skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
        wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
        showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
    };

	//Start AUIGrid
	$(document).ready(function() {
						
		// Create AUIGrid
		myGridID = GridCommon.createAUIGrid("grid_wrap",columnLayout, "", gridPros);

		doGetCombo('/services/performanceMgmt/selectMemberTypeList','', '', 'cmbMemberTypeId', 'S', '');
		doGetCombo('/services/performanceMgmt/selectSurveyStusList','', '', 'cmbSurveyStusId', 'S', '');

						
		//search
		$("#search").click(function() {
			//var cmbMemberTypeId22 = $("#cmbMemberTypeId").val();
			//alert(cmbMemberTypeId22);
											
			Common.ajax("GET","/services/performanceMgmt/selectSurveyEventList",$("#listSForm").serialize(),function(result) {
				console.log("성공.");
				console.log("data : "+ result);
				AUIGrid.setGridData(myGridID,result);
			});
										
		});

						
		$("#clear").click(function() {
			$("#cmbMemberTypeId").val('');
			$("#eventName").val('');
			$("#eventDate").val('');
			$("#eventMemCode").val('');
			$("#cmbSurveyStusId").val('');
		});

		
		//excel Download
		$('#excelDown').click(function() {
			GridCommon.exportTo("grid_wrap", 'xlsx',"Survey Management");
		});

					
	});//Ready

	// AUIGrid 칼럼 설정
	var columnLayout = [ {
		dataField : "evtTypeDesc",
		headerText : 'Event Name',
		width : 200,
		editable : false
	}, {
		dataField : "memCode",
		headerText : 'In Charge of the Event',
		width : 200,
		editable : false
	}, {
		dataField : "codeDesc",
		headerText : 'Member Type',
		width : 200,
		editable : false
	}, {
		dataField : "evtDt",
		headerText : 'Date for The Event',
		width : 200,
		dataType : "date",
		formatString : "dd/mm/yyyy",
		editable : false
	}, {
		dataField : "surveyStatus",
		headerText : 'Survey Status',
		editable : false
	} ];

	//New Pop 호출
	function fn_newEvent() {
		Common.popupDiv("/services/performanceMgmt/surveyEventCreatePop.do", $("#popSForm").serializeJSON(), null, true,"surveyEventCreatePop");
	}
</script>

<section id="content">
	<!-- content start -->
	<ul class="path">
		<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
		<li>Service</li>
		<li>Survey Event Log Search</li>
	</ul>

	<aside class="title_line">
		<!-- title_line start -->
		<p class="fav">
			<a href="#" class="click_add_on">My menu</a>
		</p>
		<h2>Survey Event Log Search</h2>
		<ul class="right_btns">
			<li><p class="btn_blue">
					<a href="#" id="search"><span class="search"></span>Search</a>
				</p></li>
			<li><p class="btn_blue">
					<a href="#" id="clear"><span class="clear"></span>Clear</a>
				</p></li>
		</ul>
	</aside>
	<!-- title_line end -->

	<section class="search_table">
		<!-- search_table start -->
		<form action="#" id="popSForm" name="popSForm" method="post">
			<input type="hidden" id="popEvtTypeDesc" name="popEvtTypeDesc" /> 
			<input type="hidden" id="popMemCode" name="popMemCode" /> 
			<input type="hidden" id="popCodeDesc" name="popCodeDesc" /> 
			<input type="hidden" id="popEvtDt" name="popEvtDt" /> 
			<input type="hidden" id="popServeyStatus" name="popServeyStatus" />
		</form>


		<section class="search_table">
			<!-- search_table start -->
			<form action="#" method="post" id="listSForm" name="listSForm">

				<table class="type1">
					<!-- table start -->
					<caption>table</caption>
					<colgroup>
						<col style="width: 180px" />
						<col style="width: *" />
						<col style="width: 180px" />
						<col style="width: *" />
						<col style="width: 160px" />
						<col style="width: *" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">Member Type</th>
							<td><select id="cmbMemberTypeId" name="cmbMemberTypeId" class="w100p">
									<!-- option value="">TBD</option>
                                    <option value="">String Type</option> -->
							</select></td>
							<th scope="row">Event Name</th>
							<td><input type="text" id="eventName" name="eventName" title="" placeholder="" class="w100p" /></td>
							<th scope="row">Event Date</th>
							<td><input type="text" id="eventDate" name="eventDate" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" /></td>
						</tr>
						<tr>
							<th scope="row">Event Member Code</th>
							<td><input type="text" id="eventMemCode" name="eventMemCode" title="" placeholder="" class="w100p" /></td>
							<th scope="row">Survay Status</th>
							<td><select id="cmbSurveyStusId" name="cmbSurveyStusId" class="w100p">
									<!--<option value="">11</option>
                                    <option value="">22</option>-->
							</select></td>
							<th scope="row"></th>
							<td></td>
						</tr>
					</tbody>
				</table>
				<!-- table end -->

				<aside class="link_btns_wrap">
					<!-- link_btns_wrap start -->
				</aside>
				<!-- link_btns_wrap end -->

			</form>
		</section>
		<!-- search_table end -->


		<section class="search_result">
			<!-- search_result start -->

			<ul class="right_btns">
				<li><p class="btn_grid">
						<a href="#" id="excelDown">EXCEL DW</a>
					</p></li>
				<li><p class="btn_grid">
						<a href="#" onClick="javascript:fn_newEvent();">New Event</a>
					</p></li>
				<li><p class="btn_grid">
						<a href="#">Edit Event</a>
					</p></li>
			</ul>

			<article class="grid_wrap">
				<!-- grid_wrap start -->
				<div id="grid_wrap" style="width: 100%; height: 380px; margin: 0 auto;"></div>
			</article>
			<!-- grid_wrap end -->

		</section>
		<!-- search_result end -->

	</section>
	<!-- content end -->