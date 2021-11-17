<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<script type="text/javaScript">
    var incenGridID;
    var uploadId;
    var stusId;
    var typeId;


    $(document).ready(function() {


    	doGetCombo('/common/selectCodeList.do', '486', '', 'statusList', 'M' ,'type_multiCombo');

        createAUIGrid();

        AUIGrid.setSelectionMode(incenGridID, "singleRow");



        $("#search").click(function(){
            Common.ajax("POST", "/organization/selectLoyaltyHPUpload.do", $("#myForm").serializeJSON(), function(result) {

            	console.log(result);
            	uploadId = "";
                stusId = "";
                AUIGrid.setGridData(incenGridID, result);
            });
        });

        $('#uploadDateFr').click(function() {$("#uploadDateFr").val("");});
        $('#uploadDateTo').click(function() {$("#uploadDateTo").val("");});

    });

    function createAUIGrid() {
        var columnLayout = [ {
            dataField : "lotyUploadId",
            headerText : "Batch No",
            style : "my-column",
            editable : false
        },{
            dataField : "lotyUploadStatusName",
            headerText : "Batch Status",
            style : "my-column",
            editable : false
        },{
            dataField : "totCnt",
            headerText : "Total",
            style : "my-column",
            editable : false
        },{
            dataField : "crtDt",
            headerText : "BatchUploadDate",
            editable : false,
            dataType : "date", formatString : "dd-mm-yyyy"
        },{
            dataField : "creator",
            headerText : "Createor",
            style : "my-column",
            editable : false
        },{
            dataField : "crtDt",
            headerText : "Upload Date",
            editable : false,
            dataType : "date", formatString : "dd-mm-yyyy"

        },{
            dataField : "lotyApprovalStatusName",
            headerText : "Approval",
            style : "my-column",
            editable : false,
            visible : true

       }
        ,
        {
            dataField : "lotyApprover",
            headerText : "Approver",
            style : "my-column",
            editable : false,
            visible : true

       }
        ,{
           dataField : "lotyApproverDate",
           headerText : "Approval Date",
           editable : false,
           visible : true,
           dataType : "date", formatString : "dd-mm-yyyy"

      },
      {
          dataField : "lotyUploadStatusCode",
          headerText : "Batch Status",
          style : "my-column",
          editable : false,visible : false
      }

       ];
        // 그리드 속성 설정
        var gridPros = {

            // 페이징 사용
            usePaging : true,
            // 한 화면에 출력되는 행 개수 20(기본값:20)
            pageRowCount : 20,
            // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            skipReadonlyColumns : true,
            // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            wrapSelectionMove : true,
            // 줄번호 칼럼 렌더러 출력
            showRowNumColumn : true

        };

        incenGridID = AUIGrid.create("#grid_wrap", columnLayout,gridPros);
   }

    //multiselect setting function
    function mam_multiCombo() {
        $(function() {
            $('#memberTypeList').change(function() {
            }).multipleSelect({
                selectAll : true, // 전체선택
                width : '80%'
            }).multipleSelect("checkAll");
        });
    }
    function status_multiCombo() {
        $(function() {
            $('#statusList').change(function() {
            }).multipleSelect({
                selectAll : true, // 전체선택
                width : '80%'
            }).multipleSelect("setSelects", [1]);
        });
    }
    function type_multiCombo() {
        $(function() {
            $('#statusList').change(function() {
            }).multipleSelect({
                selectAll : true, // 전체선택
                width : '80%'
            }).multipleSelect("checkAll");
        });
    }

    //incentive new upload pop
    function newUploadPop(){
        Common.popupDiv("/organization/loyaltyHPUploadNewPop.do");
    }

    //incentive confirm pop
    function confirmUploadPop(){



    	 var selectedItems = AUIGrid.getSelectedItems(incenGridID);
         if(selectedItems.length <= 0) {
             Common.alert('<spring:message code="commission.alert.incentive.noSelect"/>');
             return;
         }


         if( selectedItems[0].item.lotyUploadStatusCode =="4"){
             Common.alert('<spring:message code="commission.alert.incentive.noActive"/>');
             return ;
         }


         if(selectedItems[0].item.lotyUploadId  !=""  && selectedItems[0].item.lotyUploadStatusCode !="4"){

             var valTemp = {"uploadId" : selectedItems[0].item.lotyUploadId };
             Common.popupDiv("/organization/loyaltyHPUploadDetailPop.do",valTemp);

         }
     }

    //incentive confirm view
    function uploadViewPop(){

    	var selectedItems = AUIGrid.getSelectedItems(incenGridID);
        if(selectedItems.length <= 0) {
            Common.alert('<spring:message code="commission.alert.incentive.noSelect"/>');
            return;
        }

        if(selectedItems[0].item.lotyUploadId  !=""  ){
            var valTemp = {"uploadId" : selectedItems[0].item.lotyUploadId };
            Common.popupDiv("/organization/loyaltyHPUploadDetailViewPop.do",valTemp);

        }

    }

    //clear button
    function fn_clearSearchForm(){
        $("#myForm")[0].reset();
        //mam_multiCombo();
        status_multiCombo();
        type_multiCombo();
    }
</script>
<section id="content">
    <!-- content start -->
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Organization</li>
        <li>Loyalty HP Status</li>
    </ul>

    <aside class="title_line">
        <!-- title_line start -->
        <p class="fav">
            <a href="#" class="click_add_on">My menu</a>

        <h2>Loyalty HP Status List</h2>
        <ul class="right_btns">
<%--             <c:if test="${PAGE_AUTH.funcView == 'Y'}"> --%>
                <li><p class="btn_blue">
                        <a href="#" id="search"><span class="search"></span><spring:message code='sys.btn.search'/></a>
                    </p></li>
<%--             </c:if> --%>
            <li><p class="btn_blue">
                    <a href="javascript:fn_clearSearchForm();"><span class="clear"></span><spring:message code='sys.btn.clear'/></a>
                </p></li>
        </ul>
    </aside>
    <!-- title_line end -->

    <section class="search_table">
        <!-- search_table start -->
        <form action="#" method="post" name="myForm" id="myForm">

            <table class="type1">
                <!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width: 120px" />
                    <col style="width: *" />
                    <col style="width: 120px" />
                    <col style="width: *" />
                    <col style="width: 120px" />
                    <col style="width: *" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row"><spring:message code='commission.text.search.batchId'/></th>
                        <td><input type="text" title="" placeholder="Batch ID" class="w100p" name="uploadId" id="uploadId" ' maxlength="20"/></td>

                        <th>createDate</th>
                        <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date " name="createDateFr" id="createDateFr" />
                        <p>To</p> <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date " name="createDateTo" id="createDateTo" /></td>
                        <th>Creator</th>
                        <td><input type="text" title="" placeholder="Creater(Username)" class="w100p" name="creator" id="creator" / maxlength="20"></td>
                    </tr>

                    <tr>
                       <th scope="row"><spring:message code='commission.text.search.batchStatus'/></th>
                        <td><select class="multy_select w100p" multiple="multiple" name="statusList[]" id="statusList">
                        </select>
                        </td>
                        <th scope="row"></th>
                        <td></td>

                        <th scope="row"></th>
                        <td>  </td>
                    </tr>

                </tbody>
            </table>
            <!-- table end -->

            <aside class="link_btns_wrap">
                <!-- link_btns_wrap start -->
                <p class="show_btn">
                    <a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a>
                </p>
                <dl class="link_list">
                    <dt>Link</dt>
                    <dd>
                        <ul class="btns">
                           <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
                                <li><p class="link_btn">
                                        <a href="javascript:confirmUploadPop();">Confirm Upload</a>
                                    </p></li>
                             </c:if>
                                <li><p class="link_btn">
                                        <a href="javascript:uploadViewPop();">View Upload Batch</a>
                                    </p></li>
                        </ul>
                        <ul class="btns">
                                <li><p class="link_btn type2">
                                        <a href="javascript:newUploadPop();">New Upload</a>
                                    </p></li>
                        </ul>
                        <p class="hide_btn">
                            <a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a>
                        </p>
                    </dd>
                </dl>
            </aside>
            <!-- link_btns_wrap end -->

        </form>
    </section>
    <!-- search_table end -->

    <section class="search_result">
        <!-- search_result start -->

        <article class="grid_wrap">
            <!-- grid_wrap start -->
            <div id="grid_wrap" style="width: 100%; height: 334px; margin: 0 auto;"></div>
        </article>
        <!-- grid_wrap end -->

    </section>
    <!-- search_result end -->

</section>
<!-- content end -->

<hr />

</body>
</html>