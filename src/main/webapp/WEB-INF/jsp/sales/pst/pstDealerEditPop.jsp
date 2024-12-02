<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript" language="javascript">

//     var moduleParam = {groupCode : 1160};
    var addrGridID;      // addrlist
    var contactGridID; // contact list
    var optionModule = {
                type: "S",
                isShowChoose: false
        };

    $(document).ready(function(){
        fn_getAddrListAjax(); // address list
        fn_getContactListAjax(); // contact list

        createCntGrid();
        createAddrGrid();

        AUIGrid.bind(addrGridID, "cellDoubleClick", function(event){
            $("#_editDealerId").val(event.item.dealerId);
            $("#_editDealerAddId").val(event.item.dealerAddId);
            Common.popupDiv('/sales/pst/dealerEditAddrUpdPop.do', $("#editForm").serializeJSON(), null , true ,'_editDiv2Pop');
        });

        // 셀 더블클릭 이벤트 바인딩 - contact 수정
        AUIGrid.bind(contactGridID, "cellDoubleClick", function(event){

            $("#_editDealerId").val(event.item.dealerId);
            $("#_editDealerCntId").val(event.item.dealerCntId);
            Common.popupDiv("/sales/pst/dealerEditCntUpdPop.do", $("#editForm").serializeJSON(), null , true, '_editDiv3Pop');
        });

        $("#_newAddr").click(function() {
        	/*Common.popupDiv('/sales/pst/editDealerNewAddressPop.do', $("#paramForm").serializeJSON(), null , true ,'_editDiv2New'); */
            /*Pass the serialized data to your popup (serialize the form into a query string format, such as dealerId=someValue&tempDealerId=&tempDealerAddrId=&tempDealerCntId=) */
            Common.popupDiv('/sales/pst/editDealerNewAddressPop.do', $("#paramForm").serialize(), null , true ,'_editDiv2New');
        });

        $("#_newContact").click(function() {

            Common.popupDiv('/sales/pst/updateDealerNewContactPop.do', $("#paramForm").serializeJSON(), null , true ,'_editDiv3New');
        });

    });

    function createAddrGrid(){

        // 데이터 형태는 다음과 같은 형태임,
        var columnLayout = [{
                dataField : "code",
                headerText : '<spring:message code="sal.title.status" />',
                width : 120,
                editable : false
            }, {
                dataField : "fullAddr",
                headerText : '<spring:message code="sal.text.fullAddr" />',
                editable : false
            }, {
                dataField : "setMain",
                headerText : '<spring:message code="sal.title.setAsMain" />',
                width:'10%',
                renderer : {
                    type : "TemplateRenderer",
                    editable : true // 체크박스 편집 활성화 여부(기본값 : false)
                },
                // dataField 로 정의된 필드 값이 HTML 이라면 labelFunction 으로 처리할 필요 없음.
                labelFunction : function (rowIndex, columnIndex, value, headerText, item ) { // HTML 템플릿 작성
                    var html = '';

                    html += '<label><input type="radio" name="setmain"  onclick="javascript: fn_setMain(' + item.dealerAddId + ','+item.dealerId+')"';

                    if(item.stusCodeId == 9){
                        html+= ' checked = "checked"';
                        html+= ' disabled = "disabled"';
                    }

                    html += '/></label>';

                    return html;
                }
            }];

        // 그리드 속성 설정
        var gridPros = {
            // 페이징 사용
            usePaging : true,
            // 한 화면에 출력되는 행 개수 20(기본값:20)
            pageRowCount : 10,
            editable : true,
            fixedColumnCount : 1,
            showStateColumn : true,
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

        addrGridID = AUIGrid.create("#addr_grid_wrap", columnLayout, gridPros);
    }

    doGetCombo('/common/selectCodeList.do', '357', '${pstDealerBasicInfo.dealerType}','editDealerType', 'S' , '');     // Dealer Type Combo Box
    CommonCombo.make('cmbDealerBranch', "/sales/pst/dealerBrnchJsonList", '' , '${pstDealerBasicInfo.dealerBrnchId}', optionModule);

    // 조회조건 combo box
    function f_multiCombo(){
        $(function() {
            $('#cmbDealerType').change(function() {

            }).multipleSelect({
                selectAll: true, // 전체선택
                width: '80%'
            });
        });
    }

    function fn_edit(){
        Common.ajax("GET", "/sales/pst/editDealer.do", $("#editForm").serialize(), function(result){
            //result alert and reload
            Common.alert("Success.", fn_success);
        }, function(jqXHR, textStatus, errorThrown) {
            try {
                console.log("status : " + jqXHR.status);
                console.log("code : " + jqXHR.responseJSON.code);
                console.log("message : " + jqXHR.responseJSON.message);
                console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);

                //Common.alert("Failed to order invest reject.<br />"+"Error message : " + jqXHR.responseJSON.message + "</b>");
                Common.alert('<spring:message code="sal.alert.msg.unableToRetrieveExchgeReq" />');
                }
            catch (e) {
                console.log(e);
                alert('<spring:message code="sal.alert.msg.savingDataPreprationFailed" />');
            }
            alert("Fail : " + jqXHR.responseJSON.message);
            });

    }

    function createCntGrid(){

        // Contact Column
        var contactColumnLayout= [
              {dataField : "stusCode", headerText : '<spring:message code="sal.title.status" />', width : '10%'},
              {dataField : "cntName", headerText : '<spring:message code="sal.text.name" />', width : '35%'},
              {dataField : "telM1", headerText : '<spring:message code="sal.text.telM" />', width : '10%'},
              {dataField : "telO", headerText : '<spring:message code="sal.text.telO" />',width : '10%'},
              {dataField : "telR", headerText : '<spring:message code="sal.text.telR" />', width : '10%' },
              {dataField : "telf",headerText : '<spring:message code="sal.text.telF" />',width : '10%'},
              {dataField : "dealerCntId", visible: false },
              {dataField : "dealerId", visible : false},
              {
                  dataField : "setMain",
                  headerText : '<spring:message code="sal.title.setAsMain" />',
                  width:'10%',
                  renderer : {
                      type : "TemplateRenderer",
                      editable : true // 체크박스 편집 활성화 여부(기본값 : false)
                  },
                  // dataField 로 정의된 필드 값이 HTML 이라면 labelFunction 으로 처리할 필요 없음.
                  labelFunction : function (rowIndex, columnIndex, value, headerText, item ) { // HTML 템플릿 작성

                      var html = '';

                      html += '<label><input type="radio" name="setmainCnt"  onclick="javascript: fn_setMainCnt(' + item.dealerCntId + ','+item.dealerId+')"';

                      if(item.stusCodeId == 9){
                          html+= ' checked = "checked"';
                          html+= ' disabled = "disabled"';
                      }

                      html += '/></label>';

                      return html;
                  }

                }];

      //그리드 속성 설정
        var gridPros = {

                usePaging           : true,         //페이징 사용
                pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)
                editable            : false,
                fixedColumnCount    : 1,
                showStateColumn     : true,
                displayTreeOpen     : false,
                selectionMode       : "singleRow",  //"multipleCells",
                headerHeight        : 30,
                useGroupingPanel    : false,        //그룹핑 패널 사용
                skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
                noDataMessage       : "No order found.",
                groupingMessage     : "Here groupping"
            };

         contactGridID = GridCommon.createAUIGrid("#contact_grid_wrap", contactColumnLayout,'',gridPros); // contact list

    }

    function fn_getAddrListAjax(){
        Common.ajax("GET", "/sales/pst/pstDealerAddrJsonList", $("#editForm").serialize(), function(result) {
            AUIGrid.setGridData(addrGridID, result);
        }
        );
    }

    // set Main Func (Confirm)
    function fn_setMain(dealerAddId, dealerId){
        $("#tempDealerId").val(dealerId);
        $("#tempDealerAddrId").val(dealerAddId);
        Common.confirm('<spring:message code="sal.confirm.msg.confirmMainAddress" />', fn_changeMainAddr, fn_noConfirm);

    }

    //call Ajax(Set Main Address)
    function fn_changeMainAddr(){
        $("#_dealerId").val($("#tempDealerId").val());
        $("#_dealerAddId").val($("#tempDealerAddrId").val());

        Common.ajax("GET", "/sales/pst/updateDealerAddressSetMain.do", $("#popForm").serialize(), function(result){
            //result alert and reload
            //Common.alert(result.message, fn_reloadPage); //차후변경가능
            Common.alert(result.message);
            $("#_close").click();
            $("#autoClose").click();
            fn_selectPstRequestDOListAjax();
        });
    }

    // main confirm => No
    function fn_noConfirm(){
        //Parent Window Method Call
        fn_pstDealerListAjax();

        $("#_close").click();
        $("#autoClose").click();
    }

    function fn_getContactListAjax(){
        Common.ajax("GET", "/sales/pst/pstDealerCntJsonList", $("#editForm").serialize(), function(result) {
            AUIGrid.setGridData(contactGridID, result);
        }
        );
    }

 // set Main Func (Confirm)
    function fn_setMainCnt(dealerCntId, dealerId){ //sys.common.alert.save // <spring:message code='sys.common.alert.save'/>

        $("#tempDealerId").val(dealerId);
        $("#tempDealerCntId").val(dealerCntId);
        Common.confirm('<spring:message code="sal.confirm.msg.confirmMainCntc" />', fn_changeMainContact, fn_noConfirmCnt);

    }

    //call Ajax(Set Main Contact)
    function fn_changeMainContact(){
        $("#_dealerId").val($("#tempDealerId").val());
        $("#_dealerCntId").val($("#tempDealerCntId").val());

        Common.ajax("GET", "/sales/pst/updateDealerContactSetMain.do", $("#popForm").serialize(), function(result){
            //result alert and reload
            //Common.alert(result.message, fn_reloadPage); //차후변경가능
            Common.alert(result.message);
            $("#_contClose").click();
            $("#autoClose").click();
            fn_selectPstRequestDOListAjax();
        });
    }

    // main confirm => No
    function fn_noConfirmCnt(){
        //Parent Window Method Call
        fn_pstDealerListAjax();

        $("#_close2").click();
        $("#autoClose").click();
        $("#_eClose").click();
    }

    function fn_success(){
        fn_pstDealerListAjax();

        $("#_eClose").click();
    }

    //resize func (tab click)
    function fn_resizefunc(gridName){
        AUIGrid.resize(gridName, 950, 300);
   }
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.editDealer" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="_eClose"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<form id="paramForm" name="paramForm" method="GET">
    <input type="hidden" id="dealerId" name="dealerId" value="${paramDealerId}">
    <input type="hidden" id="tempDealerId" name="tempDealerId">
    <input type="hidden" id="tempDealerAddrId" name="tempDealerAddrId">
    <input type="hidden" id="tempDealerCntId" name="tempDealerCntId">
</form>

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on"><spring:message code="sal.title.text.basicInfomation" /></a></li>
    <li><a href="#" onclick="javascript: fn_resizefunc(addrGridID)"><spring:message code="sal.tap.title.mainAddr" /></a></li>
    <li><a href="#" onclick="javascript: fn_resizefunc(contactGridID)"><spring:message code="sal.title.text.contact" /></a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->
    <aside class="title_line"><!-- title_line start -->
    <h2><spring:message code="sal.title.text.dealerBasicInfo" /></h2>
    </aside><!-- title_line end -->

    <ul class="right_btns">
        <li><p class="red_text"><spring:message code="sal.title.text.compulsoryField" /></p></li>
    </ul>

    <section class="search_table"><!-- search_table start -->
    <form action="#" id="editForm" name="editForm" method="GET">
    <input type="hidden" id="_editDealerId" name="editDealerId" value="${paramDealerId }">
    <input type="hidden" id="dealerId" name="dealerId" value="${paramDealerId }">
    <input type="hidden" name="editDealerAddId"   id="_editDealerAddId"/><!-- Address Id  -->
    <input type="hidden" name="editDealerCntId"   id="_editDealerCntId"> <!--Contact Id  -->
    <input type="hidden" name="_editCustId"   id="_editCustId"> <!--Contact Id  안씀-->
    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:180px" />
        <col style="width:*" />
        <col style="width:90px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row"><spring:message code="sal.title.text.dealerName" /><span class="must">*</span></th>
        <td><input type="text" id="editDealerName" name="editDealerName" value="${pstDealerBasicInfo.dealerName }" title="" placeholder="" class="w100p" /></td>
        <th scope="row"><spring:message code="sal.title.text.dealerType" /></th>
        <td>
            <select class="w100p" id="editDealerType" name="editDealerType"></select>
        </td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.text.email" /></th>
        <td><input type="text" id="editEmail" name="editEmail" value="${pstDealerBasicInfo.dealerEmail }" title="" placeholder="" class="w100p" /></td>
        <th scope="row"><spring:message code="sal.title.text.sboCode" /></th>
        <td><input type="text" id="editSboCode" name="editSboCode" value="${pstDealerBasicInfo.sboCode }" title="" placeholder="" class="w100p" /></td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.title.text.nricCompNo" /><span class="must">*</span></th>
        <td><input type="text" title="" id="editNric" name="editNric" value="${pstDealerBasicInfo.dealerNric }" placeholder="" class="w100p" /></td>
        <th scope="row"><spring:message code="sal.text.branch" /><span class="must">*</span></th>
        <td>
        <select class="w100p" id="cmbDealerBranch" name="cmbDealerBranch">
        </select>
        </td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.text.creator" /></th>
        <td><input type="text" value="${pstDealerBasicInfo.crtUserName }" title="" placeholder="" class="w100p readonly" readonly/></td>
        <th scope="row"><spring:message code="sal.text.created" /></th>
        <td><input type="text" value="${pstDealerBasicInfo.crtDt }" title="" placeholder="" class="w100p readonly" readonly/></td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.text.updator" /></th>
        <td><input type="text" value="${pstDealerBasicInfo.updUserName }" title="" placeholder="" class="w100p readonly" readonly /></td>
        <th scope="row"><spring:message code="sal.text.updator" /></th>
        <td><input type="text" value="${pstDealerBasicInfo.updDt }" title="" placeholder="" class="w100p readonly" readonly /></td>
    </tr>
    </tbody>
    </table><!-- table end -->

    </form>
    </section><!-- search_table end -->

    <ul class="center_btns mt20">
        <li><p class="btn_blue2 big"><a href="#" onclick="fn_edit()"><spring:message code="sal.btn.update" /></a></p></li>
        <li><p class="btn_blue2 big"><a href="#"><spring:message code="sal.btn.clear" /></a></p></li>
    </ul>

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->
    <aside class="title_line"><!-- title_line start -->
    <h2><spring:message code="sal.title.text.dealerMainAddr" /></h2>
    </aside><!-- title_line end -->

    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:180px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row"><spring:message code="sal.text.fullAddr" /></th>
        <td><span>${dealerAddrTop.fullAddr}</span></td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.title.remark" /></th>
        <td><span>${dealerAddrTop.rem}</span></td>
    </tr>
    </tbody>
    </table><!-- table end -->

    <aside class="title_line"><!-- title_line start -->
    <h2><spring:message code="sal.title.text.dealerAddrList" /></h2>
    </aside><!-- title_line end -->

    <ul class="right_btns">
        <li><p class="btn_grid"><a href="#" id="_newAddr"><spring:message code="sal.btn.addNewAddr" /></a></p></li>
    </ul>
  <!--   <section class="search_result">search_result start -->

    <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="addr_grid_wrap" style="width:100%; height:280px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->
</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->
    <aside class="title_line"><!-- title_line start -->
    <h2><spring:message code="sal.title.text.dealerMainCntc" /></h2>
    </aside><!-- title_line end -->

    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:180px" />
        <col style="width:*" />
        <col style="width:180px" />
        <col style="width:*" />
        <col style="width:180px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row"><spring:message code="sal.text.name" /></th>
        <td><span>${dealerCntTop.cntName}</span></td>
        <th scope="row"><spring:message code="sal.text.initial" /></th>
        <td><span>${dealerCntTop.dealerInitial}</span></td>
        <th scope="row"><spring:message code="sal.text.gender" /></th>
        <td><span>${dealerCntTop.gender}</span></td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.text.nric" /></th>
        <td><span>${dealerCntTop.nric}</span></td>
        <th scope="row"><spring:message code="sal.text.race" /></th>
        <td><span>${dealerCntTop.raceName}</span></td>
        <th scope="row"><spring:message code="sal.title.text.telMobile1" /></th>
        <td><span>${dealerCntTop.telM1}</span></td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.title.text.telMobile2" /></th>
        <td><span>${dealerCntTop.telM2}</span></td>
        <th scope="row"><spring:message code="sal.text.telO" /></th>
        <td><span>${dealerCntTop.telO}</span></td>
        <th scope="row"><spring:message code="sal.text.telR" /></th>
        <td><span>${dealerCntTop.telR}</span></td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.text.telF" /></th>
        <td><span>${dealerCntTop.telf}</span></td>
        <th scope="row"></th>
        <td><span></span></td>
        <th scope="row"></th>
        <td><span></span></td>
    </tr>
    </tbody>
    </table><!-- table end -->

    <aside class="title_line"><!-- title_line start -->
    <h2><spring:message code="sal.title.text.dealerCntcList" /></h2>
    </aside><!-- title_line end -->

    <ul class="right_btns">
        <li><p class="btn_grid"><a href="#" id="_newContact"><spring:message code="sal.title.text.addNewCntc" /></a></p></li>
    </ul>

    <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="contact_grid_wrap" style="width:100%; height:280px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->
</article><!-- tap_area end -->

</section><!-- tap_wrap end -->



</section><!-- pop_body end -->

</div><!-- popup_wrap end -->