<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
var productCompntConfigGridID;
var productCompntConfigItemGridID;
var excelListGridID;

  $(document).ready(
    function() {
        createAUIGrid();
        createProductCompntConfigItmGrid();
        createExcelAUIGrid();

        doGetComboOrder('/common/selectCodeList.do', '320', 'CODE_ID', '', 'appType', 'S', '');  //Application Type
        doGetComboAndGroup2('/common/selectProductCodeList.do', '', '1427', 'product', 'S', 'fn_setOptGrpClass'); //product
        doGetComboData('/sales/promotion/selectProductCompnt.do', '', '', 'productCompnt', 'S', '');

        AUIGrid.bind(productCompntConfigGridID, "cellClick", function(event) {
            AUIGrid.clearGridData(productCompntConfigItemGridID);

            $("#_itmDetailGridDiv").css("display", "");

            var detailParam = {
              promoId : event.item.promoId
            };

            Common.ajax("GET", "/sales/promotion/selectProductCompntConfigItmList", detailParam,
              function(result) {
                AUIGrid.setGridData(productCompntConfigItemGridID, result);
                AUIGrid.resize(productCompntConfigItemGridID);
              });
          });

  });

  function fn_multiCombo(){
      $('#appType').change(function() {
      }).multipleSelect({
          selectAll: true, // 전체선택
          width: '100%'
      });
  }

  function fn_setOptGrpClass() {
	    $("optgroup").attr("class" , "optgroup_text")
	}

  function createAUIGrid() {
    var productCompntConfigColumnLayout = [ { dataField : "appType",
                                                      headerText : '<spring:message code="sal.text.appType" />',
                                                      width : '10%',
                                                      editable : false
                                                    }, {
                                                      dataField : "stkDesc",
                                                      headerText : '<spring:message code="sal.title.text.product" />',
                                                      width : '25%',
                                                      editable : false
                                                    }, {
                                                      dataField : "promoCode",
                                                      headerText : '<spring:message code="sales.promo.promoCd" />',
                                                      width : '15%',
                                                      editable : false
                                                    }, {
                                                      dataField : "promoDesc",
                                                      headerText : '<spring:message code="sales.promo.promoNm" />',
                                                      width : '25%',
                                                      editable : false
                                                    }, {
                                                      dataField : "promoDtFrom",
                                                      headerText : '<spring:message code="sales.StartDate" />',
                                                      width : '8%',
                                                      editable : false
                                                    }, {
                                                      dataField : "promoDtEnd",
                                                      headerText : '<spring:message code="sales.EndDate" />',
                                                      width : '8%',
                                                      editable : false
                                                    }, {
                                                      dataField : "status",
                                                      headerText : '<spring:message code="sales.Status" />',
                                                      width : '8%',
                                                      editable : false
                                                    }, {
                                                      dataField : "crtUserName",
                                                      headerText : '<spring:message code="sal.text.createBy" />',
                                                      width : '8%',
                                                      editable : false
                                                    }, {
                                                      dataField : "crtDt",
                                                      headerText : '<spring:message code="sal.text.createDate" />',
                                                      width : '8%',
                                                      editable : false
                                                    }, {
                                                      dataField : "updUserName",
                                                      headerText : '<spring:message code="sal.text.updateBy" />',
                                                      width : '8%',
                                                      editable : false
                                                    }, {
                                                      dataField : "updDt",
                                                      headerText : '<spring:message code="sal.text.updateDate" />',
                                                      width : '8%',
                                                      editable : false
                                                    }, {
                                                      dataField : "promoId",
                                                      visible : false
                                                    } ];

    var gridPros = {
      usePaging : true,
      pageRowCount : 10,
      fixedColumnCount : 4,
      showStateColumn : true,
      displayTreeOpen : false,
      headerHeight : 30,
      useGroupingPanel : false,
      skipReadonlyColumns : true,
      wrapSelectionMove : true,
      showRowNumColumn : true
    };

    productCompntConfigGridID = GridCommon.createAUIGrid("#productCompntConfig_grid_wrap", productCompntConfigColumnLayout, '', gridPros);
  }



  function createExcelAUIGrid() {
    var excelColumnLayout = [ { dataField : "appType",
                                             headerText : '<spring:message code="sal.text.appType" />',
                                             width : 200,
                                             editable : false
                                           }, {
                                             dataField : "stkDesc",
                                             headerText : '<spring:message code="sal.title.text.product" />',
                                             width : 200,
                                             editable : false,
                                           }, {
                                             dataField : "promoCode",
                                             headerText : '<spring:message code="sales.promo.promoCd" />',
                                             width : 200,
                                             editable : false
                                           }, {
                                             dataField : "promoDesc",
                                             headerText : '<spring:message code="sales.promo.promoNm" />',
                                             width : 200,
                                             editable : false
                                           }, {
                                             dataField : "promoDtFrom",
                                             headerText : '<spring:message code="sales.StartDate" />',
                                             width : 200,
                                             editable : false
                                           }, {
                                             dataField : "promoDtEnd",
                                             headerText : '<spring:message code="sales.EndDate" />',
                                             width : 200,
                                             editable : false
                                           }, {
                                             dataField : "status",
                                             headerText : '<spring:message code="sales.Status" />',
                                             width : 200,
                                             editable : false
                                           }, {
                                             dataField : "crtUserId",
                                             headerText : '<spring:message code="sal.text.createBy" />',
                                             width : 200,
                                             editable : false
                                           }, {
                                             dataField : "crtDt",
                                             headerText : '<spring:message code="sal.text.createDate" />',
                                             width : 200,
                                             editable : false
                                           }, {
                                             dataField : "updUserId",
                                             headerText : '<spring:message code="sal.text.updateBy" />',
                                             width : 200,
                                             editable : false
                                           }, {
                                             dataField : "updDt",
                                             headerText : '<spring:message code="sal.text.updateDate" />',
                                             width : 200,
                                             editable : false
                                           }, {
                                             dataField : "promoId",
                                             visible : false
                                           } ];

    var excelGridPros = {
      enterKeyColumnBase : true,
      useContextMenu : true,
      enableFilter : true,
      showStateColumn : true,
      displayTreeOpen : true,
      noDataMessage : "<spring:message code='sys.info.grid.noDataMessage' />",
      groupingMessage : "<spring:message code='sys.info.grid.groupingMessage' />",
      exportURL : "/common/exportGrid.do"
    };

    excelListGridID = GridCommon.createAUIGrid("excel_list_grid_wrap", excelColumnLayout, "", excelGridPros);
  }

  function createProductCompntConfigItmGrid() {
	    var productCompntConfigItmColumnLayout = [ { dataField : "prdCompnt",
	                                                           headerText : '<spring:message code="sales.promo.text.productCompnt" />',
	                                                           width : '40%',
	                                                           editable : false
	                                                         }, {
	                                                           dataField : "effectDt",
	                                                           headerText : '<spring:message code="sales.EffectDate" />',
	                                                           width : '20%',
	                                                           editable : false
	                                                         }, {
	                                                           dataField : "expireDt",
	                                                           headerText : '<spring:message code="sales.ExpireDate" />',
	                                                           width : '20%',
	                                                           editable : false
	                                                         }];

	    var itmGridPros = {
	      showFooter : true,
	      usePaging : true,
	      pageRowCount : 10,
	      fixedColumnCount : 1,
	      showStateColumn : true,
	      displayTreeOpen : false,
	      headerHeight : 30,
	      useGroupingPanel : false,
	      skipReadonlyColumns : true,
	      wrapSelectionMove : true,
	      showRowNumColumn : true
	    };

	    productCompntConfigItemGridID = GridCommon.createAUIGrid("#productCompntConfig_itm_grid_wrap", productCompntConfigItmColumnLayout, '', itmGridPros);
	    //AUIGrid.resize(productCompntConfigItemGridID, 960, 300);

	  }

  $(function() {
	  $('#appType').change(function() {
		  if(!FormUtil.isEmpty($('#appType').val())){
		  doGetComboData('/sales/promotion/selectProductCompntPromotionList.do', {appType: $('#appType').val() , stkId : $('#product').val() , effectStartDt : $('#effectStartDt').val() , effectEndDt : $('#effectEndDt').val() , config : 1 }, '' , 'promoId', 'S' , '');
		  }
	  });

	  $('#_btnSearch').click(function() {
	      if (fn_validSearchList())
	        fn_getProductCompntConfigList();
	    });

	  $("#newProdCompntConfig").click(
		   function() {
		          Common.popupDiv("/sales/promotion/productCompntConfigAddPop.do", '', null, true, '_insDiv');
		});

	  $("#editProdCompntConfig").click(
			   function() {
				   rowIdx = AUIGrid.getSelectedIndex(productCompntConfigGridID)[0];
			        if (rowIdx > -1) {
			          Common.popupDiv("/sales/promotion/productCompntConfigModifyPop.do", { promoId : AUIGrid.getCellValue(productCompntConfigGridID, rowIdx, "promoId") }, null, true, '_insDiv');
			        }else {
			            Common.alert('<spring:message code="sal.alert.msg.noRecordSelected" />');
			            return false;
			        }
			});

	  $('#excelDown').click(
		      function() {
		        var excelProps = {
		          fileName : "Product Component Configuration List",
		          exceptColumnFields : AUIGrid.getHiddenColumnDataFields(excelListGridID)
		        };
		        AUIGrid.exportToXlsx(excelListGridID, excelProps);
		    });
  });

  function fn_getProductCompntConfigList() {
	    Common.ajax("GET", "/sales/promotion/selectProductCompntConfigList.do",
	        $("#searchForm").serialize(), function(result) {
	          AUIGrid.setGridData(productCompntConfigGridID, result);
	          AUIGrid.setGridData(excelListGridID, result);
	          AUIGrid.clearGridData(productCompntConfigItemGridID);
	        });
	  }

  function fn_validSearchList() {
	    var isValid = true, msg = "";

	    if ((!FormUtil.isEmpty($('#effectStartDt').val()) && FormUtil.isEmpty($('#effectEndDt').val()))
	        || (FormUtil.isEmpty($('#effectStartDt').val()) && !FormUtil.isEmpty($('#effectEndDt').val()))) {
	      msg += '<spring:message code="sales.promo.alert.msg.selectEffectiveDate" /><br/>';
	      isValid = false;
	    }

	    if (!isValid)
	      Common.alert('<spring:message code="sales.promo.text.productCompntConfigSearch" />'
	                         + DEFAULT_DELIMITER + "<b>" + msg + "</b>");
	    return isValid;
	  }

</script>
<section id="content">
  <ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li><spring:message code="sales.promo.title.productCompntConfig" /></li>
    <li><spring:message code="sales.promo.title.productCompntConfig" /></li>
  </ul>

  <aside class="title_line">
    <p class="fav">
      <a href="#" class="click_add_on">My menu</a>
    </p>
    <h2>
      <spring:message code="sales.promo.title.productCompntConfig" />
    </h2>
    <ul class="right_btns">
      <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
        <li>
          <p class="btn_blue">
            <a href="#" id="newProdCompntConfig"><spring:message code="sal.btn.new" /></a>
          </p>
        </li>
      </c:if>
      <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
        <li>
          <p class="btn_blue">
            <a href="#" id="editProdCompntConfig"><spring:message code="sales.btn.edit" /></a>
          </p>
        </li>
      </c:if>
      <c:if test="${PAGE_AUTH.funcView == 'Y'}">
        <li>
          <p class="btn_blue">
            <a href="#" id="_btnSearch"><span class="search"></span>
            <spring:message code="sal.btn.search" /></a>
          </p>
        </li>
      </c:if>
      <li>
        <p class="btn_blue">
          <a href="#" onclick="javascript:$('#searchForm').clearForm();"><span class="clear"></span>
          <spring:message code="sal.btn.clear" /></a>
        </p>
      </li>
    </ul>
  </aside>

  <section class="search_table">
    <form id="searchForm">
      <table class="type1">
        <caption>table</caption>
        <colgroup>
          <col style="width: 150px" />
          <col style="width: *" />
          <col style="width: 160px" />
          <col style="width: *" />
          <col style="width: 130px" />
          <col style="width: *" />
        </colgroup>
        <tbody>
          <tr>
            <th scope="row"><spring:message code="sal.text.appType" /><span class="must">*</span></th>
            <td>
              <select id="appType" name="appType" class="w100p"></select>
            </td>
            <th scope="row"><spring:message code="sal.text.product" /></th>
            <td>
              <select id="product" name="product" class="w100p"></select>
            </td>
            <th scope="row"><spring:message code="sales.promo.text.productCompnt" /></th>
            <td>
               <select class="w100p" id="productCompnt" name="productCompnt">
			  <option value=""><spring:message code="sal.combo.text.chooseOne" /></option></select>
            </td>
          </tr>
          <tr>
          <th scope="row"><spring:message code="sal.title.text.promo" /></th>
            <td>
              <select id="promoId" name="promoId" class="w100p"></select>
            </td>
            <th scope="row"><spring:message code="sales.EffectDate" /><span class="must">*</span></th>
            <td>
              <div class="date_set w100p">
                <p>
                  <input id="effectStartDt" name="effectStartDt" type="text" value="${bfDay}" title="Effective Start Date" placeholder="DD/MM/YYYY" class="j_date" />
                </p>
                <span>To</span>
                <p>
                  <input id="effectEndDt" name="effectEndDt" type="text" value="${toDay}" title="Effect End Date" placeholder="DD/MM/YYYY" class="j_date" />
                </p>
              </div>
            </td>
            <th></th>
            <td></td>
          </tr>

        </tbody>
      </table>

      <aside class="link_btns_wrap">
        <p class="show_btn">
          <a href="#">
            <img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a>
        </p>
        <dl class="link_list">
          <dt>
            <spring:message code="sal.title.text.link" />
          </dt>
          <dd>
            <ul class="btns">
            </ul>
            <p class="hide_btn">
              <a href="#">
                <img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a>
            </p>
          </dd>
        </dl>
      </aside>
    </form>
  </section>

  <section class="search_result">
    <c:if test="${PAGE_AUTH.funcUserDefine4 == 'Y'}">
      <ul class="right_btns">
        <li>
          <p class="btn_grid">
            <a href="#" id="excelDown"><spring:message code="sal.btn.generate" /></a>
          </p>
        </li>
      </ul>
    </c:if>
    <aside class="title_line">
    </aside>

    <article class="grid_wrap">
      <div id="productCompntConfig_grid_wrap" style="width: 100%; height: 300px; margin: 0 auto;"></div>
      <div id="excel_list_grid_wrap" style="display: none;"></div>
    </article>

     <div id="_itmDetailGridDiv">
      <aside class="title_line">
        <h3>
          <spring:message code="sales.promo.text.productCompnt" />
        </h3>
      </aside>
      <article class="grid_wrap">
        <div id="productCompntConfig_itm_grid_wrap" style="width: 100%; height: 300px; margin: 0 auto;"></div>
      </article>
    </div>

  </section>
</section>
<hr />
