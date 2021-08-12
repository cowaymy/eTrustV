<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

    //AUIGrid 생성 후 반환 ID
    var listGridID;

    var keyValueList = [];


    var timerId = null;

    var AUTH_CHNG = "${PAGE_AUTH.funcChange}";

    $(document).ready(function(){


        //AUIGrid 그리드를 생성합니다.
        createAUIGrid();




        // 셀 클릭 이벤트 바인딩
        //AUIGrid.bind(listGridID, "selectionChange", auiGridSelectionChangeHandler);

        doGetComboOrder('/common/selectCodeList.do', '320', 'CODE_ID', '', 'list_promoAppTypeId', 'M', 'fn_multiCombo'); //Common Code
        doGetCombo('/common/selectCodeList.do',  '76', '', 'list_promoTypeId',    'M', 'fn_multiCombo'); //Promo Type
        doGetComboDataStatus('/status/selectStatusCategoryCdList.do',  {selCategoryId : 3, parmDisab : 0}, '', 'list_promoStusId', 'M', 'fn_multiCombo'); //Promo Type
    });




    function fn_delApptype() {
        $("#promoAppTypeId").find("option").each(function() {
            if(this.value == '2286') {
                $(this).remove();
            }
        });
    }
    function fn_delApptype2() {
        $("#list_promoAppTypeId").find("option").each(function() {
            if(this.value == '2286') {
                $(this).remove();
            }
        });
    }


    function createAUIGrid() {

        //AUIGrid 칼럼 설정
        var columnLayout = [
            { headerText : "<spring:message code='sales.AppType2'/>",        dataField : "promoAppTypeName", editable : false,   width : 100 }
          , { headerText : "<spring:message code='sales.promo.promoType'/>", dataField : "promoTypeName",    editable : false,   width : 100 }
          , { headerText : "<spring:message code='sales.promo.promoCd'/>",   dataField : "promoCode",        editable : false,   width : 140 }
          , { headerText : "<spring:message code='sales.promo.promoNm'/>",   dataField : "promoDesc",        editable : false }
          , { headerText : "<spring:message code='sales.StartDate'/>",       dataField : "promoDtFrom",      editable : false,   width : 100 }
          , { headerText : "<spring:message code='sales.EndDate'/>",         dataField : "promoDtEnd",       editable : false,   width : 100 }
          , { headerText : "<spring:message code='sales.Status'/>",          dataField : "status",      editable : false,    width : 80 }
          , {
              dataField : "b2b",
              headerText : "B2B",
              editable : true,
              width : 50,
              renderer : {
                  type : "CheckBoxEditRenderer",
                  showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                  editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                  checkValue : "1", // true, false 인 경우가 기본
                  unCheckValue : "0",
                  styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
                      if(item.b2b == "1") {
                          return "disable-check-style";
                      }
                      return null;
                  },


              }
          }
          , {
              dataField : "chs",
              headerText : "CHS",
              editable : true,
              width : 50,
              renderer : {
                  type : "CheckBoxEditRenderer",
                  showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                  editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                  checkValue : "1", // true, false 인 경우가 기본
                  unCheckValue : "0",
                  styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
                      if(item.b2b == "1") {
                          return "disable-check-style";
                      }
                      return null;
                  },


              }
          }
          ,{ headerText : "promoId",        dataField : "promoId",        visible : false}
          , { headerText : "promoAppTypeId", dataField : "promoAppTypeId", visible : false}
          ];

        //그리드 속성 설정
        var gridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)
            editable            : true,
            fixedColumnCount    : 1,
            showStateColumn     : false,
            displayTreeOpen     : false,
          //selectionMode       : "singleRow",  //"multipleCells",
            headerHeight        : 30,
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
            noDataMessage       : "No order found.",
            groupingMessage     : "Here groupping"
        };

        listGridID = GridCommon.createAUIGrid("list_promo_grid_wrap", columnLayout, "", gridPros);
    }



    // 리스트 조회.
    function fn_selectPromoListAjax() {
        console.log('fn_selectPromoListAjax START');
        Common.ajax("GET", "/sales/promotion/selectPromotionList.do", $("#listSearchForm").serialize(), function(result) {
            AUIGrid.setGridData(listGridID, result);
        });
    }

    function fn_doSaveStatus() {
        console.log('!@# fn_doSaveStatus START');

        /* var promotionVO = {
            salesPromoMGridDataSetList : GridCommon.getEditData(listGridID)
        };

        Common.ajax("POST", "/sales/ccp/savePromoB2BUpdate.do", promotionVO, function(result) {

            Common.alert("<spring:message code='sales.promo.msg1'/>" + DEFAULT_DELIMITER + "<b>"+result.message+"</b>");

            fn_selectPromoListAjax();

        },  function(jqXHR, textStatus, errorThrown) {
            try {
                console.log("status : " + jqXHR.status);
                console.log("code : " + jqXHR.responseJSON.code);
                console.log("message : " + jqXHR.responseJSON.message);
                console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);

                Common.alert("<spring:message code='sal.alert.title.saveFail'/>" + DEFAULT_DELIMITER + "<b><spring:message code='sales.fail.msg'/></b>");
            }
            catch (e) {
                console.log(e);
//              alert("Saving data prepration failed.");
            }

//          alert("Fail : " + jqXHR.responseJSON.message);
        }); */

        var editedRowItems = AUIGrid.getEditedRowItems(listGridID);

        if(editedRowItems.length <= 0) {
            Common.alert("<spring:message code="sal.alert.msg.noUpdateItem" />");
            return ;
        }
        console.log(editedRowItems);
        param = GridCommon.getEditData(listGridID);

            Common.confirm("<spring:message code='sys.common.alert.save'/>",function(){
                Common.ajax(
                        "POST",
                        "/sales/ccp/savePromoB2BUpdate.do",
                        param,
                        function(result){ // Success
                            Common.alert("<spring:message code='sys.msg.success'/>");
                            fn_selectPromoListAjax();
                        },
                        function(jqXHR, textStatus, errorThrown){ // Error
                            alert("Fail : " + jqXHR.responseJSON.message);
                        }
                )
            });
    }

    $(function(){

        $('#btnSaveStatus').click(function() {
            fn_doSaveStatus();
        });
        $('#btnSrch').click(function() {
            fn_selectPromoListAjax();
        });
        $('#btnClear').click(function() {
            $('#listSearchForm').clearForm();
        });
    });




    function fn_multiCombo(){
        $('#list_promoAppTypeId').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택
            width: '100%'
        });
        $('#list_promoAppTypeId').multipleSelect("checkAll");
        $('#list_promoTypeId').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택
            width: '100%'
        });
        $('#list_promoTypeId').multipleSelect("checkAll");
        $('#list_promoStusId').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택
            width: '100%'
        });
        $('#list_promoStusId').multipleSelect("checkAll");

        fn_delApptype2();
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

<!--****************************************************************************
    CONTENT START
*****************************************************************************-->
<section id="content">
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li><spring:message code='sales.path.sales'/></li>
    <li><spring:message code='sales.path.Promotion'/></li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>CCP Auto-Approve Promotion Management </h2>
<ul class="right_btns">

    <li><p class="btn_blue"><a id="btnSaveStatus" href="#"><spring:message code='sales.btn.save'/></a></p></li>
    <li><p class="btn_blue"><a id="btnSrch" href="#"><span class="search"></span><spring:message code='sales.btn.search'/></a></p></li>
    <li><p class="btn_blue"><a id="btnClear" href="#"><span class="clear"></span><spring:message code='sales.btn.clear'/></a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="listSearchForm" name="listSearchForm" action="#" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code='sales.promo.promoApp'/></th>
    <td>
    <select id="list_promoAppTypeId" name="promoAppTypeId" class="multy_select w100p" multiple="multiple"></select>
    </td>
    <th scope="row"><spring:message code='sales.promo.promoType'/></th>
    <td>
    <select id="list_promoTypeId" name="promoTypeId" class="multy_select w100p" multiple="multiple"></select>
    </td>
    <th scope="row"><spring:message code='sales.EffectDate'/></th>
    <td>
    <input id="list_promoDt" name="promoDt" type="text" title="<spring:message code='sales.EffetDate'/>" value="${toDay}" placeholder="DD/MM/YYYY" class="j_date w100p" />
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='sales.Status'/></th>
    <td>
    <select id="list_promoStusId" name="promoStusId" class="w100p"></select>
    </td>
    <th scope="row"><spring:message code='sales.promo.promoCd'/></th>
    <td><input id="list_promoCode" name="promoCode" type="text" title="" placeholder="" class="w100p" /></td>
    <th scope="row"><spring:message code='sales.promo.promoNm'/></th>
    <td><input id="list_promoDesc" name="promoDesc" type="text" title="" placeholder="" class="w100p" /></td>
</tr>
</tbody>
</table><!-- table end -->



</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="list_promo_grid_wrap" style="width:100%; height:480; margin:0 auto;"></div>
</article><!-- grid_wrap end -->



</section><!-- search_result end -->

</section><!-- content end -->
