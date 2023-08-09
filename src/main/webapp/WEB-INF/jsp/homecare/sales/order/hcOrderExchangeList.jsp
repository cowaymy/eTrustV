<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

	//AUIGrid 생성 후 반환 ID
    var myGridID;
	var basicAuth = false;

    $(document).ready(function(){
        // AUIGrid 그리드를 생성합니다.
        createAUIGrid();

        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(myGridID, "cellDoubleClick", function(event){
            $("#soExchgId").val(event.item.soExchgId);
            $("#exchgType").val(event.item.soExchgTypeId);
            $("#exchgStus").val(event.item.soExchgStusId);
            $("#exchgCurStusId").val(event.item.soCurStusId);
            $("#salesOrderNo").val(event.item.salesOrdNo);
            $("#salesOrderId").val(event.item.soId);

            Common.popupDiv("/sales/order/orderExchangeDetailPop.do", $("#detailForm").serializeJSON());
        });
        // 셀 클릭 이벤트 바인딩

        //Basic Auth (update Btn)
        if('${PAGE_AUTH.funcChange}' == 'Y'){
            basicAuth = true;
        }
    });

    function createAUIGrid() {
        // AUIGrid 칼럼 설정

        // 데이터 형태는 다음과 같은 형태임,
        //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
        var columnLayout = [
            {
                dataField : "codeName",
                headerText : '<spring:message code="sal.title.type" />',
                width : 160,
                editable : false
            },
            {
                dataField : "code",
                headerText : '<spring:message code="sal.title.status" />',
                width : 100,
                editable : false
            },
            {
                dataField : "salesOrdNo",
                headerText : '<spring:message code="sal.text.ordNo" />',
                width : 120,
                editable : false
            },
            {headerText : "BNDL No.",                                              dataField : "bndlNo",               editable : false, width : 130},
            {
                dataField : "salesDt",
                headerText : '<spring:message code="sal.text.ordDate" />',
                dataType : "date",
                formatString : "dd/mm/yyyy" ,
                width : 130,
                editable : false
            },
            {
                dataField : "name",
                headerText : '<spring:message code="sal.title.custName" />',
                editable : false
            },
            {
            	dataField : "nric1",
            	headerText : '<spring:message code="sal.title.text.nricCompNo" />',
            	width : 170,
            	editable : false
            },
            {
            	dataField : "soExchgCrtDt",
            	headerText : '<spring:message code="sal.text.createDate" />',
            	width : 130,
            	editable : false
            },
            {
                dataField : "crtUserName",
                headerText : '<spring:message code="sal.text.creator" />',
                width : 140,
                editable : false
           },
           {
               dataField : "soExchgId",
               visible : false
           },
           {
               dataField : "soExchgTypeId",
               visible : false
           },
           {
               dataField : "soExchgStusId",
               visible : false
           },
           {
               dataField : "soCurStusId",
               visible : false
           },
           {
               dataField : "soId",
               visible : false
           },{
               dataField : "atchFileGrpId",
               headerText : "RCO Attachment",
               width : 150,
               renderer : {
                   type : "ButtonRenderer",
                   labelText : "View",
                   onclick : function(rowIndex, columnIndex, value, item) {

                     if(value)
                        return fn_loadAttachment(value);

                     Common.alert("No Attachment uploaded");
                   }
               },
                editable : false
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
            groupingMessage : "Here groupping"
        };

        myGridID = AUIGrid.create("#list_grid_wrap", columnLayout, gridPros);
    }

    //f_multiCombo 함수 호출이 되어야만 multi combo 화면이 안깨짐.
    doGetCombo('/common/selectCodeList.do', '56', '','cmbExcType', 'M' , 'f_multiCombo');    // Exchange Type Combo Box
    doGetCombo('/common/selectCodeList.do', '10', '','cmbAppType', 'M' , 'f_multiCombo');   // Application Type Combo Box

    // 조회조건 combo box
    function f_multiCombo(){
        $(function() {
            $('#cmbExcType').change(function() {

            }).multipleSelect({
                selectAll: true, // 전체선택
                width: '80%'
            });
            $('#cmbAppType').change(function() {

            }).multipleSelect({
                selectAll: true, // 전체선택
                width: '80%'
            });

            $('#cmbExcType').multipleSelect("checkAll");
            $('#cmbAppType').multipleSelect("checkAll");
        });
    }

    // 조회
    function fn_searchListAjax(){

    	console.log($("#searchForm").serialize());

    	Common.ajax("GET", "/homecare/sales/order/hcOrderExchangeList", $("#searchForm").serialize(), function(result) {
            AUIGrid.setGridData(myGridID, result);
        });
    }

    function fn_rawData(){
    	Common.popupDiv("/sales/order/orderExchangeRawDataPop.do", null, null, true);
    }

    function fn_stkRetList(){
        Common.popupDiv("/sales/order/orderExchangeProductReturnPop.do", null, null, true);
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

    function fn_loadAttachment(atchFileGrpId){
        Common.ajax("Get", "/sales/order/selectAttachList.do", {atchFileGrpId :atchFileGrpId} , function(result) {

          let data = result[0];

          Common.ajax("GET", "/eAccounting/webInvoice/getAttachmentInfo.do", { atchFileGrpId : data.atchFileGrpId, atchFileId : data.atchFileId }, function(result) {
              let fileSubPath = result.fileSubPath.replace('\', '/'');

              if(result.fileExtsn == "jpg" || result.fileExtsn == "png" || result.fileExtsn == "gif") {
                  window.open(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
              } else {
                  window.open("/file/fileDownWeb.do?subPath=" + fileSubPath + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
              }
          });
        });
    }
</script>

<!-- content start -->
<section id="content">
	<ul class="path">
	    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
	    <li>Sales</li>
	    <li>Order list</li>
	</ul>

	<!-- title_line start -->
	<aside class="title_line">
		<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
		<h2><spring:message code="sal.title.text.exchangeList" /></h2>
		<ul class="right_btns">
		    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
		    <li><p class="btn_blue"><a href="#" onClick="fn_searchListAjax()"><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li>
		    </c:if>
		    <li><p class="btn_blue"><a href="#" onclick="javascript:$('#searchForm').clearForm();"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p></li>
		</ul>
	</aside>
	<!-- title_line end -->

	<!-- search_table start -->
	<section class="search_table">
		<form id="detailForm" name="detailForm" method="post">
		    <input type="hidden" id="soExchgId" name="soExchgId">
		    <input type="hidden" id="exchgType" name="exchgType">
		    <input type="hidden" id="exchgStus" name="exchgStus">
		    <input type="hidden" id="exchgCurStusId" name="exchgCurStusId">
		    <input type="hidden" id="salesOrderId" name="salesOrderId">
		</form>

		<form id="searchForm" name="searchForm" method="post" autocomplete=off>
	        <!-- table start -->
			<table class="type1">
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
					    <th scope="row"><spring:message code="sal.title.text.exchangeType" /></th>
					    <td>
					        <select id="cmbExcType" name="cmbExcType" class="multy_select w100p" multiple="multiple"></select>
					    </td>
					    <th scope="row"><spring:message code="sal.title.text.exchangeStatus" /></th>
					    <td>
						    <select id="cmbExcStatus" name="cmbExcStatus" class="multy_select w100p" multiple="multiple">
						        <option value="1" selected><spring:message code="sal.btn.active" /></option>
						        <option value="4"><spring:message code="sal.combo.text.compl" /></option>
						        <option value="10"><spring:message code="sal.combo.text.cancel" /></option>
						    </select>
					    </td>
					    <th scope="row"><spring:message code="sal.title.text.requestDate" /></th>
					    <td>
						    <div class="date_set w100p"><!-- date_set start -->
							    <p><input type="text" id="startCrtDt" name="startCrtDt" title="Create start Date" value="${bfDay}" placeholder="DD/MM/YYYY" class="j_date" /></p>
							    <span><spring:message code="sal.title.to" /></span>
							    <p><input type="text" id="endCrtDt" name="endCrtDt" title="Create end Date" value="${toDay}" placeholder="DD/MM/YYYY" class="j_date" /></p>
		    			    </div><!-- date_set end -->
					    </td>
					</tr>
					<tr>
					    <th scope="row"><spring:message code="sal.text.ordNum" /></th>
					    <td>
	                        <input type="text" id="salesOrdNo" name="salesOrdNo" title="" placeholder="Order Number" class="w100p" />
					    </td>
					        <th scope="row"><spring:message code="sal.text.appType" /></th>
					    <td>
					        <select id="cmbAppType" name="cmbAppType" class="multy_select w100p" multiple="multiple"></select>
					    </td>
					    <th scope="row"><spring:message code="sal.title.text.requestor" /></th>
					    <td>
					        <input type="text" title="" id="crtUserName" name="crtUserName" placeholder="Requestor (Username)" class="w100p" />
					    </td>
					</tr>
					<tr>
					    <th scope="row"><spring:message code="sal.text.customerId" /></th>
					    <td>
					        <input type="text" title="" id="custId" name="custId" placeholder="Customer ID (Number Only)" class="w100p" />
					    </td>
					    <th scope="row"><spring:message code="sal.text.custName" /></th>
					    <td>
					        <input type="text" title="" id="custName" name="custName" placeholder="Customer Name" class="w100p" />
					    </td>
					    <th scope="row"><spring:message code="sal.title.text.nricCompNo" /></th>
					    <td>
					        <input type="text" title="" id="custIc" name="custIc" placeholder="NRIC/Company Number" class="w100p" />
					    </td>
					</tr>
					<tr>
                        <th scope="row">Bundle Number</th>
                        <td><input type="text" title="bndlNo" id="bndlNo" name="bndlNo" placeholder="Bundle Number" class="w100p" /></td>
                        <th scope="row"></th>
                        <td></td>
                        <th scope="row"></th>
                        <td></td>
                    </tr>
				</tbody>
			</table>
			<!-- table end -->

		    <!-- link_btns_wrap start -->
			<aside class="link_btns_wrap">
				<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
				<dl class="link_list">
				    <dt><spring:message code="sal.title.text.link" /></dt>
				    <dd>
					    <ul class="btns">
					        <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
					        <li><p class="link_btn type2"><a href="#" onClick="fn_rawData()"><spring:message code="sal.title.text.exchangeRawData" /></a></p></li>
					        </c:if>
					        <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
					        <li><p class="link_btn type2"><a href="#" onClick="fn_stkRetList()"><spring:message code="sal.title.text.exchangeStkRet" /></a></p></li>
					        </c:if>
					    </ul>
					    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
				    </dd>
				</dl>
			</aside>
			<!-- link_btns_wrap end -->
		</form>
	</section>
	<!-- search_table end -->

	<!-- search_result start -->
	<section class="search_result">
		<article class="grid_wrap"><!-- grid_wrap start -->
		    <div id="list_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
		</article><!-- grid_wrap end -->
	</section>
	<!-- search_result end -->

</section><!-- content end -->

