<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
	//AUIGrid 생성 후 반환 ID
	var myGridID;
	var basicAuth = false;
	var MEM_TYPE     = '${SESSION_INFO.userTypeId}';
	var TODAY_DD      = "${toDay}";


	$(document).ready(function() {

		// AUIGrid 그리드를 생성합니다.
		createAUIGrid();

		//        AUIGrid.setSelectionMode(myGridID, "singleRow");

		// 셀 더블클릭 이벤트 바인딩
		AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
			$("#invReqId").val(event.item.invReqId);
			Common.popupDiv("/sales/order/orderInvestInfoPop.do", $("#popForm").serializeJSON(), null, true, 'dtPop');
		});

		if($("#memType").val() == 1 || $("#memType").val() == 2){
			$("#orgTable").show();
		}else{
			$("#orgTable").hide();
		}

		if($("#memType").val() == 1){
            $("#grpCode").removeAttr("readonly");
        }else if($("#memType").val() == 2){
        	$("#grpCode").attr("readonly");
        	$("#grpCode").val($("#initGrpCode").val());
        	$("#grpCode").attr("class", "w100p readonly");
        }

		//Basic Auth (update Btn)
        if('${PAGE_AUTH.funcChange}' == 'Y'){
            basicAuth = true;
        }
	});

	function createAUIGrid() {
		var columnLayout = [ {
			dataField : "invReqNo",
			headerText : "<spring:message code='sal.text.requestNo' />",
			width : 140,
			editable : false
		}, {
			dataField : "invReqPartyName",
			headerText : "<spring:message code='sal.text.requestParty' />",
			width : 160,
			editable : false
		}, {
			dataField : "invReqStusName",
			headerText : "<spring:message code='sal.text.requestStatus' />",
			width : 170,
			editable : false
		}, {
			dataField : "salesOrdNo",
			headerText : "<spring:message code='sal.title.text.ordNop' />",
			editable : false
		}, {
			dataField : "invReqCrtUserName",
			headerText : "<spring:message code='sal.text.requestBy' />",
			editable : false
		}, {
			dataField : "invReqUpdDt",
			headerText : "<spring:message code='sal.text.requestAt' />",
			dataType : "date",
            formatString : "dd/mm/yyyy" ,
			width : 170,
			editable : false
		}, {
			dataField : "invReqId",
			visible : false
		} ];

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
			showRowNumColumn : true,

			groupingMessage : "Here groupping"
		};

		//myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
		myGridID = GridCommon.createAUIGrid("#list_grid_wrap", columnLayout, '', gridPros);
	}

	// 리스트 조회.
	function fn_orderInvestigationListAjax() {

//		if( $("#salesOrdNo").val() ==""  &&  $("#invReqNo").val() ==""  &&  $("#invReqCrtUserName").val() ==""  ){
//            Common.alert("You must key-in at least one of Order No / Request No / Request User");
//            return ;
//        }

		Common.ajax("GET", "/sales/order/orderInvestJsonList", $("#searchForm").serialize(), function(result) {
			AUIGrid.setGridData(myGridID, result);
		}
		);
	}

	function fn_clear() {
		$("#invReqNo").val('');
		$("#startCrtDt").val('');
		$("#endCrtDt").val('');
		$("#salesOrdNo").val('');
		$("#invReqCrtUserName").val('');
		$(".multy_select").prop("checked", false);
		$("#invReqPartyId").val('');
	}


function fn_checkOrderValidDate(){
    var todayDD = Number(TODAY_DD.substr(0, 2));
    var todayYY = Number(TODAY_DD.substr(6, 4));


    if (MEM_TYPE == 2) {
        if(todayYY >= 2018) {
            if(todayDD > 25) { // Block if date >= 25th of the month
                 var msg = 'Disallow to create new request for Order Investigation after 25th of the Month.';
                Common.alert('<spring:message code="sal.alert.msg.actionRestriction" />' + DEFAULT_DELIMITER + "<b>" + msg + "</b>", '');
                return "Warning";

            }
        }
    }
}


	function fn_goSingle() {
//		$("#searchForm").attr({
//			"target" : "_self",
//			"action" : getContextPath() + "/sales/order/orderNewRequestSingleList.do"
//		}).submit();

       if(fn_checkOrderValidDate() == "Warning") {
             return;
     }else{
		Common.popupDiv("/sales/order/orderNewRequestSingleListPop.do", $("#popForm").serializeJSON(), null, true, 'singlePop');
     }
	}

	function fn_goBatch() {
		Common.popupDiv("/sales/order/orderNewRequestBatchListPop.do", $("#popForm").serializeJSON(), null, true, 'batchPop');
	}

	function fn_rawData() {
		Common.popupDiv("/sales/order/orderInvestigationRequestRawDataPop.do", null, null, true);
	}

	function fn_goCallResult(){
	    location.replace("/sales/order/orderInvestCallRecallList.do");
	}

	$.fn.clearForm = function() {
        return this.each(function() {
            var type = this.type, tag = this.tagName.toLowerCase();
            if (tag === 'form'){
                return $(':input',this).clearForm();
            }
            if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea'){
                this.value = '';
                this.text='';
            }else if (type === 'checkbox' || type === 'radio'){
                this.checked = false;
                this.text='';
            }else if (tag === 'select'){
                this.selectedIndex = -1;
                this.text='';
            }
        });
    };
</script>
<form id="popForm" method="post">
	<input type="hidden" name="invReqId" id="invReqId" />
	<input type="hidden" name="memType" id="memType" value="${memType }"/>
	<input type="hidden" name="initGrpCode" id="initGrpCode" value="${grpCode }"/>
</form>
<section id="content">
	<!-- content start -->
	<ul class="path">
		<li><img
			src="${pageContext.request.contextPath}/resources/images/common/path_home.gif"
			alt="Home" /></li>
		<li>Sales</li>
		<li>Order list</li>
	</ul>

	<aside class="title_line">
		<!-- title_line start -->
		<p class="fav">
			<a href="#" class="click_add_on">My menu</a>
		</p>
		<h2><spring:message code="sal.page.title.orderInvestigationRequestSearch" /></h2>
		<ul class="right_btns">
			<li><p class="btn_blue">
					<a href="#" onClick="fn_goSingle()"><spring:message code="sal.btn.newRequestSingle" /></a>
				</p></li>
			<li><p class="btn_blue">
					<a href="#" onClick="fn_goBatch()"><spring:message code="sal.btn.newRequestBatch" /></a>
				</p></li>
		    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
			<li><p class="btn_blue">
					<a href="#" onClick="fn_orderInvestigationListAjax()"><span
						class="search"></span><spring:message code="sal.btn.search" /></a>
				</p></li>
		    </c:if>
			<li><p class="btn_blue">
					<a href="#" onClick="fn_clear()" onclick="javascript:$('#searchForm').clearForm();"><span class="clear"></span><spring:message code="sal.btn.clear" /></a>
				</p></li>
		</ul>
	</aside>
	<!-- title_line end -->


	<section class="search_table">
		<!-- search_table start -->
		<form id="searchForm" name="searchForm" action="#" method="post">

			<table class="type1">
				<!-- table start -->
				<caption>table</caption>
				<colgroup>
					<col style="width: 150px" />
					<col style="width: *" />
					<col style="width: 160px" />
					<col style="width: *" />
					<col style="width: 170px" />
					<col style="width: *" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row"><spring:message code="sal.text.requestNo" /></th>
						<td><input type="text" id="invReqNo" name="invReqNo" title=""
							placeholder="" class="w100p" /></td>
						<th scope="row"><spring:message code="sal.text.requestDate" /></th>
						<td>
							<div class="date_set w100p">
								<!-- date_set start -->
								<p>
									<input type="text" id="startCrtDt" name="startCrtDt"
										title="Create start Date"
										placeholder="DD/MM/YYYY" class="j_date" />
								</p>
								<span><spring:message code="sal.text.to" /></span>
								<p>
									<input type="text" id="endCrtDt" name="endCrtDt"
										title="Create end Date"
										placeholder="DD/MM/YYYY" class="j_date" />
								</p>
							</div>
							<!-- date_set end -->
						</td>
						<th scope="row"><spring:message code="sal.text.ordNo" /></th>
						<td><input type="text" title="" id="salesOrdNo"
							name="salesOrdNo" placeholder="" class="w100p" /></td>
					</tr>
					<tr>
						<th scope="row"><spring:message code="sal.text.requestUser" /></th>
						<td><input type="text" title="" id="invReqCrtUserName"
							name="invReqCrtUserName" placeholder="" class="w100p" /></td>
						<th scope="row"><spring:message code="sal.text.requestStatus" /></th>
						<td><select class="multy_select w100p" id="invReqStusId"
							name="invReqStusId" multiple="multiple">
								<option value="1">Active</option>
								<option value="44">Pending</option>
								<option value="5">Approved</option>
								<option value="6">Rejected</option>
						</select></td>
						<th scope="row"><spring:message code="sal.text.requestParty" /></th>
						<td><select class="w100p" id="invReqPartyId"
							name="invReqPartyId">
								<option value=""><spring:message code="sal.text.requestParty" /></option>
								<option value="770">Web User</option>
								<option value="771">Cody User</option>
						</select></td>
					</tr>
				</tbody>
			</table>
			<table class="type1" id="orgTable">
                <!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width: 150px" />
                    <col style="width: *" />
                    <col style="width: 160px" />
                    <col style="width: *" />
                    <col style="width: 170px" />
                    <col style="width: *" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row"><spring:message code="sal.text.orgCode" /></th>
                        <td><input type="text" title="" id="orgCode" name="orgCode" value="${orgCode }" placeholder="" class="w100p readonly" readonly/></td>
                        <th scope="row"><spring:message code="sal.text.grpCode" /></th>
                        <td><input type="text" title="" id="grpCode" name="grpCode" placeholder="" class="w100p" /></td>
                        <th scope="row"><spring:message code="sal.text.detpCode" /></th>
                        <td><input type="text" title="" id="deptCode" name="deptCode" placeholder="" class="w100p" /></td>
                    </tr>
                </tbody>
            </table>
			<!-- table end -->
		</form>

		<aside class="link_btns_wrap">
			<!-- link_btns_wrap start -->
			<p class="show_btn">
				<a href="#"><img
					src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif"
					alt="link show" /></a>
			</p>
			<dl class="link_list">
				<dt>Link</dt>
				<dd>
					<ul class="btns">
						<li>
						    <p class="link_btn type2">
								<a href="#" onClick="fn_rawData()"><spring:message code="sal.btn.requestRawData" /></a>
							</p>
					    </li>
					    <li><p class="link_btn type2"><a href="#" onclick="javascript:fn_goCallResult();"><spring:message code="sal.btn.callResult" /></a></p></li>
					</ul>
					<p class="hide_btn">
						<a href="#"><img
							src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif"
							alt="hide" /></a>
					</p>
				</dd>
			</dl>
		</aside>
		<!-- link_btns_wrap end -->

	</section>
	<!-- search_table end -->

	<section class="search_result">
		<!-- search_result start -->

		<!-- title_line start
<aside class="title_line">
<h3>Request Raw Data</h3>
</aside>!-- title_line end -->

		<article class="grid_wrap">
			<!-- grid_wrap start -->
			<div id="list_grid_wrap"
				style="width: 100%; height: 480px; margin: 0 auto;"></div>
		</article>
		<!-- grid_wrap end -->

	</section>
	<!-- search_result end -->

</section>
<!-- content end -->

<hr />
