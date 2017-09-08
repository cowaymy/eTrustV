<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

	//AUIGrid 생성 후 반환 ID
	var listGridID;
    
    var keyValueList = [{"code":"1", "value":"Active"}, {"code":"8", "value":"Inactive"}];

    $(document).ready(function(){
        //AUIGrid 그리드를 생성합니다.
        createAUIGrid();

        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(listGridID, "cellDoubleClick", function(event) {
            fn_setDetail(listGridID, event.rowIndex);
        });
        
        doGetCombo('/common/selectCodeList.do', '320', '', 'list_promoAppTypeId', 'M', 'fn_multiCombo'); //Promo Application
        doGetCombo('/common/selectCodeList.do',  '76', '', 'list_promoTypeId',    'M', 'fn_multiCombo'); //Promo Type
    });

    // 컬럼 선택시 상세정보 세팅.
    function fn_setDetail(gridID, rowIdx){
//        Common.popupWin("listSearchForm", "/sales/promotion/promotionModifyPop.do?promoId=31555");
        Common.popupDiv("/sales/promotion/promotionModifyPop.do", { promoId : AUIGrid.getCellValue(gridID, rowIdx, "promoId") });
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
        
        var promotionVO = {            
            salesPromoMGridDataSetList : GridCommon.getEditData(listGridID)
        };
        
        Common.ajax("POST", "/sales/promotion/updatePromoStatus.do", promotionVO, function(result) {

            Common.alert("Promotion Status Saved" + DEFAULT_DELIMITER + "<b>"+result.message+"</b>");
            
            fn_selectPromoListAjax();
            
        },  function(jqXHR, textStatus, errorThrown) {
            try {
                console.log("status : " + jqXHR.status);
                console.log("code : " + jqXHR.responseJSON.code);
                console.log("message : " + jqXHR.responseJSON.message);
                console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);

                Common.alert("Failed To Save" + DEFAULT_DELIMITER + "<b>Failed to save order.<br />"+"Error message : " + jqXHR.responseJSON.message + "</b>");
            }
            catch (e) {
                console.log(e);
//              alert("Saving data prepration failed.");
            }

//          alert("Fail : " + jqXHR.responseJSON.message);
        });
    }
    
    $(function(){
        $('#btnNew').click(function() {
            Common.popupDiv("/sales/promotion/promotionRegisterPop.do");
        });
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

    function createAUIGrid() {
        
    	//AUIGrid 칼럼 설정
        var columnLayout = [
            { headerText : "Application<br>Type",  dataField : "promoAppTypeName", editable : false,   width : 100 }
          , { headerText : "Promotion<br>Type",    dataField : "promoTypeName",    editable : false,   width : 100 }
          , { headerText : "Promotion Code",    dataField : "promoCode",        editable : false,   width : 140 }
          , { headerText : "Promotion Name",    dataField : "promoDesc",        editable : false }
          , { headerText : "Start",             dataField : "promoDtFrom",      editable : false,   width : 100 }
          , { headerText : "End",               dataField : "promoDtEnd",       editable : false,   width : 100 }
          , { headerText : "Status",            dataField : "promoStusId",      editable : true,    width : 80
            , labelFunction : function( rowIndex, columnIndex, value, headerText, item) { 
                                  var retStr = "";
                        		  for(var i=0,len=keyValueList.length; i<len; i++) {
                        			  if(keyValueList[i]["code"] == value) {
                        				  retStr = keyValueList[i]["value"];
                        			      break;
                        		      }
                        		  }
                        	      return retStr == "" ? value : retStr;
                              }
            , editRenderer : {
    		      type       : "ComboBoxRenderer",
    			  list       : keyValueList, //key-value Object 로 구성된 리스트
    			  keyField   : "code", // key 에 해당되는 필드명
    			  valueField : "value" // value 에 해당되는 필드명
    		  }}
          , { headerText : "promoId",           dataField : "promoId",          visible  : false,   width : 120 }
          ];

        //그리드 속성 설정
        var gridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)            
            editable            : true,            
            fixedColumnCount    : 1,            
            showStateColumn     : false,             
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
        
        listGridID = GridCommon.createAUIGrid("list_promo_grid_wrap", columnLayout, "", gridPros);
    }
    
    function fn_multiCombo(){
        $('#list_promoAppTypeId').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택 
            width: '100%'
        });            
        $('#list_promoTypeId').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택 
            width: '100%'
        });
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
	<li>Sales</li>
	<li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Promotion Maintenance </h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a id="btnNew" href="#" >New</a></p></li>
    <li><p class="btn_blue"><a id="btnSaveStatus" href="#">Save</a></p></li>
	<li><p class="btn_blue"><a id="btnSrch" href="#"><span class="search"></span>Search</a></p></li>
	<li><p class="btn_blue"><a id="btnClear" href="#"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="listSearchForm" name="listSearchForm" action="#" method="post">

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
	<th scope="row">Promotion Application</th>
	<td>
	<select id="list_promoAppTypeId" name="promoAppTypeId" class="multy_select w100p" multiple="multiple"></select>
	</td>
	<th scope="row">Promotion Type</th>
	<td>
	<select id="list_promoTypeId" name="promoTypeId" class="multy_select w100p" multiple="multiple"></select>
	</td>
	<th scope="row">Effective Date</th>
	<td>
	<input id="list_promoDt" name="promoDt" type="text" title="Create Promotion Date" placeholder="DD/MM/YYYY" class="j_date w100p" />
	</td>
</tr>
<tr>
	<th scope="row">Status</th>
	<td>
	<select id="list_promoStusId" name="promoStusId" class="w100p">
		<option value="">Choose One</option>
		<option value="1">Active</option>
		<option value="8">Inactive</option>
	</select>
	</td>
	<th scope="row">Promotion Code</th>
	<td><input id="list_promoCode" name="promoCode" type="text" title="" placeholder="" class="w100p" /></td>
	<th scope="row">Promotion Name</th>
	<td><input id="list_promoDesc" name="promoDesc" type="text" title="" placeholder="" class="w100p" /></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
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
	<p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
	</dd>
</dl>
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->
<!--
<ul class="right_btns">
	<li><p class="btn_grid"><a href="#">CANCEL</a></p></li>
	<li><p class="btn_grid"><a href="#">ADD</a></p></li>
	<li><p class="btn_grid"><a href="#">SAVE</a></p></li>
</ul>
-->
<article class="grid_wrap"><!-- grid_wrap start -->
<div id="list_promo_grid_wrap" style="width:100%; height:480; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->
