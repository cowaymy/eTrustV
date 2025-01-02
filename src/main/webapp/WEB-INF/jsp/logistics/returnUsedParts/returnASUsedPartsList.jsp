<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<!--
 DATE               BY     VERSION        REMARK
 ----------------------------------------------------------------
 18/12/2019  ONGHC  1.0.0          Create AS Used Filter
 19/12/2019  ONGHC  1.0.1          Add AS Type Selection
 06/03/2020  ONGHC  1.0.2          Remove Branch Search
 18/07/2023  WAWA   1.0.3          Add AS Type, Error Code & Error Description
 -->

    <style type="text/css">

/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
  text-align: left;
}

/* 커스컴 disable 스타일*/
.mycustom-disable-color {
  color: #cccccc;
}

/* 그리드 오버 시 행 선택자 만들기 */
.aui-grid-body-panel table tr:hover {
  background: #D9E5FF;
  color: #000;
}

.aui-grid-main-panel .aui-grid-body-panel table tr td:hover {
  background: #D9E5FF;
  color: #000;
}
</style>
<script type="text/javascript"
 src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">
  var listGrid;
  var subGrid;
  var userCode;
  var paramdata;
  var t1 = "<spring:message code='log.head.nopartsreturn'/>" + " " + "<spring:message code='sales.reason'/>"
  var comboData = [ {
    "codeId" : "Y",
    "codeName" : "Yes"
  }, {
    "codeId" : "N",
    "codeName" : "No"
  } ];
  var comboData1 = [ {
    "codeId" : "62",
    "codeName" : "Filter"
  }, {
    "codeId" : "63",
    "codeName" : "Spare Part"
  } ];
  var comboData2 = [ {
    "codeId" : "03",
    "codeName" : "CT"
  }];
  var comboData3 = [ {
    "codeId" : "A",
    "codeName" : "A"
  }, {
    "codeId" : "B",
    "codeName" : "B"
  } ];

  var uomlist = f_getTtype('364', '');
  var oldQty;
  var oldSerial;

  /* Required Date 초기화 */
  var today = new Date();
  today.setDate(today.getDate() - 7);
  var dd = today.getDate();
  var mm = today.getMonth() + 1;
  var yyyy = today.getFullYear();

  if (dd < 10) {
    dd = '0' + dd;
  }

  if (mm < 10) {
    mm = '0' + mm;
  }

  today = (dd + '/' + mm + '/' + yyyy);

  var rescolumnLayout = [
      {
        dataField : "rnum",
        headerText : "<spring:message code='log.head.rownum'/>",
        width : 120,
        height : 30,
        visible : false
      },
      {
        dataField : "seq",
        headerText : "seq",
        width : 120,
        height : 30,
        visible : false
      },
      {
        dataField : "serviceOrder",
        headerText : "<spring:message code='service.grid.ASNo'/>",
        width : 120,
        height : 30,
        editable : false
      },
      {
          dataField : "asrNo",
          headerText : "<spring:message code='service.grid.ASRNo'/>",
          width : 120,
          height : 30,
          editable : false
        },
      {
        dataField : "orderNo",
        headerText : "<spring:message code='log.head.orderno'/>",
        width : 120,
        height : 30,
        editable : false
      },
     {
        dataField : "installDt",
        headerText : "<spring:message code='service.title.InstallationDate'/>",
        width : 120,
        height : 30,
        editable : false
      },
      {
         dataField : "productCode",
         headerText : "<spring:message code='sal.text.productCode'/>",
         width : 120,
         height : 30,
         editable : false
       },
       {
          dataField : "productName",
          headerText : "<spring:message code='sal.text.productName'/>",
          width : 120,
          height : 30,
          editable : false
       },
       {
         dataField : "productCat",
         headerText : "<spring:message code='sal.text.productCategory'/>",
         width : 120,
         height : 30,
         editable : false
       },
      {
        dataField : "code",
        headerText : "<spring:message code='log.head.branch'/>",
        width : 120,
        height : 30,
        editable : false
      },
      {
        dataField : "brnchName",
        headerText : "<spring:message code='log.head.branchname'/>",
        width : 120,
        height : 30,
        editable : false
      },
      {
        dataField : "memCode",
        headerText : "<spring:message code='log.head.ctno'/>",
        width : 120,
        height : 30,
        editable : false
      },
      {
        dataField : "name",
        headerText : "<spring:message code='sal.text.ctName'/>",
        width : 120,
        height : 30,
        editable : false
      },
      {
        dataField : "serviceDate",
        headerText : "<spring:message code='log.head.servicedate'/>",
        width : 120,
        height : 30,
        editable : false
      },
      {
        dataField : "materialCode",
        headerText : "<spring:message code='log.head.materialcode'/>",
        width : 120,
        height : 30,
        editable : true
      },
      {
        dataField : "materialName",
        headerText : "<spring:message code='log.head.materialname'/>",
        width : 120,
        height : 30,
        editable : false
      },
      {
        dataField : "serial",
        headerText : "Serial Number (Prev.)",
        width : 120,
        height : 30,
        editable : true
      },
      {
          dataField : "serialNumber",
          headerText : "Serial Number (New.)",
          width : 120,
          height : 30,
          editable : true
       },
      {
        dataField : "qty",
        headerText : "<spring:message code='log.head.qty'/>",
        width : 120,
        height : 30
      },
		{dataField: "unmatchId",headerText :"Unmatch Reason Id"     ,width:120    ,height:30, editable:false, visible:false},
      {dataField: "unmatchReason",headerText :"Unmatch Reason"     ,width:120    ,height:30, editable:false},
      {
         dataField : "asAging",
         headerText : "<spring:message code='service.grid.asAging'/>",
         width : 120,
         height : 30
      },
      {
        dataField : "noPartsReturn",
        headerText : t1,
        width : 120,
        height : 30,
        readOnly : true,
        labelFunction : function(rowIndex, columnIndex, value, headerText, item) {
          var retStr = "";

          for (var i = 0, len = uomlist.length; i < len; i++) {
            if (uomlist[i]["code"] == value) {
              retStr = uomlist[i]["codeName"];
              break;
            }
          }
          return retStr == "" ? value : retStr;
        },
        editRenderer : {
          type : "ComboBoxRenderer",
          showEditorBtnOver : true,
          list : uomlist,
          keyField : "code",
          valueField : "codeName",
          validator : function(oldValue, newValue, item, dataField) {
              var isValid = true;

              for (var a=0; a < uomlist.length; a++) {
                if (uomlist[a].code == newValue) {
                  return;
                } else {
                  isValid = false;
                }
              }

              for (var a=0; a < uomlist.length; a++) {
                if (uomlist[a].codeName == newValue) {
                  return;
                } else {
                  isValid = false;
                }
              }

              if (!isValid) {
                return { "validate" : isValid, "message" :"Invalid code. Please choose code using icon beside.", "newValue" : ""};
              } else {
                return;
              }
          }
        }
      },
      {
        dataField : "text",
        headerText : "<spring:message code='log.label.rmk'/>",
        width : 120,
        height : 30
      },
      {
        dataField : "returnComplete",
        headerText : "<spring:message code='log.head.returncomplete'/>",
        width : 120,
        height : 30,
        editable : false
      },
      {
        dataField : "returnCompleteDate",
        headerText : "<spring:message code='log.head.returncompletedate'/>",
        width : 120,
        height : 30,
        editable : false
      }, {
        dataField : "serialChk",
        headerText : "<spring:message code='log.head.serialchk'/>",
        width : 120,
        height : 30,
        editable : false
      },
      {dataField: "pendScanName",headerText :"Serial Check Status"     ,width:120    ,height:30, editable:false},
      {dataField: "pendScan",headerText :"Serial Check Status"     ,width:120    ,height:30, editable:false, visible:false },
      {
        dataField : "customer",
        headerText : "<spring:message code='log.head.customer'/>",
        width : 120,
        height : 30,
        editable : false
      }, {
        dataField : "customerName",
        headerText : "<spring:message code='log.head.customername'/>",
        width : 120,
        height : 30,
        editable : false
      }, {
        dataField : "deftyp",
        headerText : "<spring:message code='service.text.defTyp'/>",
        width : 120,
        height : 30,
        editable : false
      }, {
        dataField : "defcde",
        headerText : "<spring:message code='service.text.defCde'/>",
        width : 120,
        height : 30,
        editable : false
      },{
          dataField : "asType",
          headerText : "AS Type",
          width : 120,
          height : 30,
          editable : false
        }, {
          dataField : "errorDetails",
          headerText : "AS Error Code",
          width : 120,
          height : 30,
          editable : false
        }, {
          dataField : "errordesc",
          headerText : "AS Error Description",
          width : 120,
          height : 30,
          editable : false
        }
      ];

  var subgridpros = {
    rowIdField : "rnum",
    usePaging : false,
    editable : true,
    noDataMessage : "<spring:message code='sys.info.grid.noDataMessage'/>",
    useGroupingPanel : true,
    showRowCheckColumn : true,
    showRowAllCheckBox : true,
    showFooter : false,
    rowCheckableFunction : function(rowIndex, isChecked, item) {
      oldQty = item.qty;
      oldSerial = item.serial;
      var checkedItems = AUIGrid.getCheckedRowItemsAll(listGrid);

      for (var i = 0; i < checkedItems.length; i++) {
      }
    },
  };

  // READY
  $(document).ready(
    function() {

    /**********************************
     * Header Setting
     **********************************/
    doDefCombo(comboData1, '', 'searchMaterialType', 'S', '');
    doDefCombo(comboData, '', 'searchComplete', 'S', '');
    doDefCombo(comboData2, '03', 'searchlocgb', 'S', '');

    doGetComboData('/logistics/returnasusedparts/getBchBrowse.do', '03', '', 'searchBranch', 'S', '');
    //doGetComboData('/logistics/returnasusedparts/getDefGrp.do', '', '', 'searchDefTyp', 'M', 'f_multiComboType');
    doGetComboData('/logistics/returnasusedparts/getDefGrp.do', '', '', 'searchDefTyp', 'S', '');
    doGetComboData('/logistics/returnasusedparts/getProdCat.do', '', '', 'searchProdCat', 'S', '');

    $("#servicesdt").val(today);
    doSysdate(0, 'serviceedt');
    doDefCombo(comboData3, 'A', 'searchlocgrade', 'S', '');

    /**********************************
     * Header Setting End
     ***********************************/
    listGrid = AUIGrid.create("#main_grid_wrap", rescolumnLayout, subgridpros);
    AUIGrid.bind(listGrid, "cellClick", function(event) {});
    AUIGrid.bind(listGrid, "cellDoubleClick", function(event) {});
    AUIGrid.bind(listGrid, "ready", function(event) {});

    AUIGrid.bind(listGrid, "cellEditEnd",
       function(event) {
         var checkedItems = AUIGrid.getCheckedRowItemsAll(listGrid);
         if (checkedItems.length <= 0) {
           Common.alert("<spring:message code='service.msg.NoRcd'/>");
           return false;
         } else {
           if (event.dataField == "materialCode") {
             var matcode = AUIGrid.getCellValue(listGrid, event.rowIndex, "materialCode");
             if (matcode.length > 15) {
               Common.alert('Material must LESS THAN 15 characters.');
               AUIGrid.setCellValue(listGrid, event.rowIndex, "materialCode", "");
               return false;
             }

             var indexnum = event.rowIndex;
             validMatCodeAjax(matcode, indexnum);

           }
         }
       });
     }
  );

  $(function() {
    $('#search').click(function() {
      if (validation()) {
        SearchListAjax();
      }
    });

    $('#clear').click(function() {
      testFunc();
    });

    $('#complete').click(
      function() {
        var chkfalg;
        var allChecked = false
        var checkedItems = AUIGrid.getCheckedRowItemsAll(listGrid);
        if (checkedItems.length <= 0) {
          Common.alert("<spring:message code='service.msg.NoRcd'/>");
          return false;
        } else {
          if (checkedItems.length > 0) {
            for (var i = 0; i < checkedItems.length; i++) {
              if (checkedItems[i].returnComplete == "Y") {
                chkfalg = "Y";
                Common.alert("<spring:message code='log.msg.rcdPrc'/>");
              } else {
                chkfalg = "N";
              }

              if (checkedItems[i].materialCode == "" || checkedItems[i].materialCode == undefined) {
            	  Common.alert("<spring:message code='sys.msg.necessary' arguments='Material Code' htmlEscape='false'/>");
                return false;
              }
            }
          }

          if (chkfalg == "N") {
            if (f_validatation('save')) {
              upReturnParts();
            }
          }
        }
      }
    );

	$('#pending').click(function() {
        var chkfalg;
        var allChecked = false;
        var checkedItems = AUIGrid.getCheckedRowItemsAll(listGrid);
           if(checkedItems.length <= 0) {
               Common.alert('No data selected.');
               return false;
           }else{
        	   if(checkedItems.length > 0){
                   for (var i = 0 ; i < checkedItems.length ; i++){
                	   /* console.log("checkedItems[i].unmatchId" + checkedItems[i].unmatchId);
                	   if(checkedItems[i].unmatchId != undefined){
                           Common.alert('Please uncheck service order which contains unmatch reason.');
                           return false;
                       } */
                	   if(checkedItems[i].pendScan == "Y"){
                           Common.alert('Please uncheck service order which already Pending Scan.');
                           return false;
                       }
                	   if (checkedItems[i].returnComplete =="Y"){
                		   Common.alert('Kindly Uncheck items which already processed.');
                           return false;
                       }
                   }
        	   }


        	   Common.confirm("Do you want to save? </br> Note that : </br> Order WITH serial number will update to status pending </br> and WITHOUT will be update to status complete",function(){
                   //Common.alert("confirm to update");
        		   var data = {};
			        var checkdata = AUIGrid.getCheckedRowItemsAll(listGrid);
			        data.checked = checkdata;

			        Common.ajax("POST", "/logistics/returnasusedparts/returnPartsUpdatePend.do", data, function(result) {
			            if (result.data == 0) {
			                Common.alert(result.message);
			                $("#search").click();
			            }
			            else {
			                Common.alert('Already processed.');
			            }

			        })
               });
      }
   });

	$('#scan').click(function() {
		if ($("#searchLoc").val() == '' || $("#searchLoc").val() == undefined) {
            Common.alert('Please select one Location');
            return false;
	    }
		else if($("#searchLoc").val().length>1){
			console.log($("#searchLoc").val().length);
            Common.alert('Please select one Location only');
            return false;
		}

		fn_scanSerialPop();
	   });

function fn_scanSerialPop(){
    var checkedItems = AUIGrid.getCheckedRowItems(listGrid);

    Common.ajax("GET", "/logistics/returnasusedparts/getCodyInfo.do", {memCode:$("#searchLoc").val()[0]}, function(result) {

        if (result != null && result.code == "00") {
        	if(result.data != null && result.data != undefined){
         	   var param = {
       	            "branch" : $("#searchBranch").val(),
       	            "branchName" : $("#searchBranch :selected").text(),
       	            "codyId" : result.data.memId,
       	            "codyMem" : result.data.memCode
       	        };
       	        Common.popupDiv("/logistics/returnasusedparts/scanASSerialPop.do", param, null, true, '_divScanASSerialPop');
        	}
        	else{
                Common.alert('Cody not found');
                return false;
        	}
        }
    });
}

$('#failed').click(function() {
    var chkfalg;
    var allChecked = false
    var checkedItems = AUIGrid.getCheckedRowItemsAll(listGrid);
       if(checkedItems.length <= 0) {
           Common.alert('No data selected.');
           return false;
       }else{
           var access_auth2 = "${PAGE_AUTH.funcUserDefine2}";
            console.log("access_auth2 " + access_auth2);
            for (var i = 0 ; i < checkedItems.length ; i++){
            	if(checkedItems[i].unmatchId == undefined || checkedItems[i].unmatchId == ""){
            		Common.alert('Only record(s) with Unmatched Reason able to failed.');
                    return false;
            	}
            	if(checkedItems[i].pendScan != "Y"){
                    Common.alert('Record(s) not in poending scan status.');
                    return false;
                }
            	if (checkedItems[i].returnComplete =="Y"){
                    Common.alert('Kindly Uncheck items which already processed.');
                    return false;
                }
            }

            if(access_auth2 != "Y"){ //branch admin
            	for (var i = 0 ; i < checkedItems.length ; i++){
                    if(checkedItems[i].unmatchId !=  "6815"){ //branch admin only can failed unmatch reason "used filter without scan label"
                    	Common.alert('Unmatched Filer not allow to update return. </br> Kindly seek management approval.');
                        return false;
                    }
                }
            }

            Common.confirm("Unmatched Filter due to without label. </br> Do you confirm the unused filter returned is correct?",function(){
                var data = {};
                 var checkdata = AUIGrid.getCheckedRowItemsAll(listGrid);
                 data.checked = checkdata;

                 Common.ajax("POST", "/logistics/returnasusedparts/returnPartsUpdateFailed.do", data, function(result) {
                     if (result.data == 0) {
                         Common.alert(result.message);
                         $("#search").click();
                     }
                     else {
                         Common.alert('Already processed.');
                         $("#search").click();
                     }

                 })
            });
       }

  });

    $("#download").click(
      function() {
        GridCommon.exportTo("main_grid_wrap", 'xlsx',"Return Used Parts List")
      }
    );

    $('#cancle').click(function() {
      cancleReturnParts();
    });

    $('#btnHSUsedFilterListing').click(
      function() {
        Common.popupDiv("/logistics/returnasusedparts/HSUsedFilterListingPop.do", null, null, true);
    });

    $('#searchProdCat').change(
      function() {
        var searchProdCat = $('#searchProdCat').val();
        var param = {
                     grp : $('#searchProdCat').val()
                    }

        doGetComboData('/logistics/returnasusedparts/getdefCde.do', param, '', 'searchDefCde', 'M', 'f_multiComboType');
      });

    $('#searchDefTyp').change(
      function() {
        var searchDefTyp = $('#searchDefTyp').val();
        var param = {
                      grp : $('#searchDefTyp').val()
                    }
        doGetComboData('/logistics/returnasusedparts/getSltCde.do', param, '', 'searchSltCde', 'M', 'f_multiComboType');
      });

    $('#searchBranch').change(
      function() {
        if ($('#searchBranch').val() != null && $('#searchBranch').val() != "") {
          var searchlocgb = $('#searchlocgb').val();
          var searchBranch = $('#searchBranch').val();

          if ($('#searchlocgb').val() == null || $('#searchlocgb').val() == "") {
            Common.alert("<spring:message code='sys.msg.necessary' arguments='Location Type' htmlEscape='false'/>");
            //doGetComboData('/logistics/totalstock/selectTotalBranchList.do', '', '', 'searchBranch', 'S', '');
            return false;
          }

          var param = { searchlocgb : searchlocgb,
                        grade : $('#searchlocgrade').val(),
                        searchBranch : searchBranch
                      }

          doGetComboData('/logistics/returnasusedparts/getLoc.do', param, '', 'searchLoc', 'M', 'f_multiComboType');
        }
      }
    );

    $('#searchlocgrade').change(
      function() {
        var searchlocgb = $('#searchlocgb').val();
        var param = { searchlocgb : searchlocgb,
                      grade : $('#searchlocgrade').val()
                    }
        doGetComboData('/common/selectStockLocationList2.do', param, '', 'searchLoc', 'M', 'f_multiComboType');
    });

    $('#searchlocgb').change(
      function() {
        var searchlocgb = $('#searchlocgb').val();

        if ($('#searchBranch').val() != null && $('#searchBranch').val() != "") {
          var searchBranch = $('#searchBranch').val();
          var param = { searchlocgb : searchlocgb,
                        grade : $('#searchlocgrade').val(),
                        searchBranch : searchBranch
                      }
          doGetComboData('/logistics/returnasusedparts/getLoc.do', param, '', 'searchLoc', 'M', 'f_multiComboType');
        }
      }
    );
  });

  function testFunc() {
    var url = "/logistics/returnasusedparts/ReturnUsedPartsTest.do";
    var param = "param=BS8362806";

    Common.ajax("GET", url, param, function(data) {
      //AUIGrid.setGridData(listGrid, data.data);
      alert(data);
      $("#search").click();
    });
  }

  /* function deltestFunc() {
    var url = "/logistics/returnasusedparts/ReturnUsedPartsDelTest.do";
    var param = "param=BS8362776";

    Common.ajax("GET", url, param, function(data) {
      //AUIGrid.setGridData(listGrid, data.data);
      alert(data);
      $("#search").click();
    });
  } */

  function SearchListAjax() {
    var url = "/logistics/returnasusedparts/returnPartsSearchList.do";
    var param = $('#searchForm').serialize();

    Common.ajax("GET", url, param, function(data) {
      console.log(data.data);
      AUIGrid.setGridData(listGrid, data.data);
    });
  }

  function f_getTtype(g, v) {
    var rData = new Array();
    $.ajax({
      type : "GET",
      url : "/common/selectCodeList.do",
      data : {
        groupCode : g,
        orderValue : 'CRT_DT',
        likeValue : v
      },
      dataType : "json",
      contentType : "application/json;charset=UTF-8",
      async : false,
      success : function(data) {
        $.each(data, function(index, value) {
          var list = new Object();
          list.code = data[index].code;
          list.codeId = data[index].codeId;
          list.codeName = data[index].codeName;
          rData.push(list);
        });
      },
      error : function(jqXHR, textStatus, errorThrown) {
        Common.alert("Draw ComboBox['" + obj
            + "'] is failed. \n\n Please try again.");
      },
      complete : function() {
      }
    });

    return rData;
  }

  function upReturnParts() {
    var data = {};
    var checkdata = AUIGrid.getCheckedRowItemsAll(listGrid);
    data.checked = checkdata;

    Common.ajax("POST", "/logistics/returnasusedparts/returnPartsUpdate.do", data, function(result) {
      if (result.data == 0) {
        Common.alert(result.message);
        $("#search").click();
      } else {
        Common.alert("<spring:message code='log.msg.rcdPrc'/>");
      }
    })
  }

  function cancleReturnParts() {
    var data = {};
    var checkdata = AUIGrid.getCheckedRowItemsAll(listGrid);
    data.checked = checkdata;

    Common.ajax("POST", "/logistics/returnasusedparts/returnPartsCanCle.do", data, function(result) {
      Common.alert(result.message);
    })
  }

  function f_validatation(v) {
    if (v == 'save') {
      var checkedItems = AUIGrid.getCheckedRowItemsAll(listGrid);
      for (var i = 0; i < checkedItems.length; i++) {
        if (checkedItems[i].qty == 0 || checkedItems[i].qty == null || checkedItems[i].qty == "" || undefined) {
          Common.alert("<spring:message code='sys.msg.necessary' arguments='Request Quantity' htmlEscape='false'/>");
          return false;
        }
      }
      return true;
    }
  }

  function validMatCodeAjax(matcode, indexnum) {
    var url = "/logistics/returnasusedparts/validMatCodeSearch.do";
    var param = {
      "matcode" : matcode
    };

    Common.ajax("GET", url, param, function(data) {
      if (data.data == 0) {
    	  Common.alert("<spring:message code='sys.msg.invalid' arguments='Product Code' htmlEscape='false'/>");
        AUIGrid.setCellValue(listGrid, indexnum, "materialCode", "");
      }
    });
  }

  function f_multiComboType() {
    $(function() {
      $('#searchLoc').change(function() {
      }).multipleSelect({
        selectAll : true
      });

      //$('#searchDefTyp').change(function() {
      //}).multipleSelect({
      //  selectAll : true
      //});

      $('#searchSltCde').change(function() {
      }).multipleSelect({
        selectAll : true
      });

      $('#searchDefCde').change(function() {
      }).multipleSelect({
        selectAll : true
      });
    });
  }

  function validation() {
    if ($("#searchlocgb").val() == '' || $("#searchlocgb").val() == undefined) {
      Common.alert("<spring:message code='sys.msg.necessary' arguments='Location Type' htmlEscape='false'/>");
      return false;
    //} else if ($("#searchBranch").val() == '' || $("#searchBranch").val() == undefined) {
    //  Common.alert("<spring:message code='sys.msg.necessary' arguments='Branch' htmlEscape='false'/>");
    //  return false;
    //} else if ($("#searchLoc").val() == '' || $("#searchLoc").val() == undefined) {
      //Common.alert("<spring:message code='sys.msg.necessary' arguments='Location' htmlEscape='false'/>");
      //return false;
    } else {
      return true;
    }
  }
</script>
<section id="content">
 <!-- content start -->
 <ul class="path">
  <li><img
   src="${pageContext.request.contextPath}/resources/images/common/path_home.gif"
   alt="Home" /></li>
  <li><spring:message code='log.title.log'/></li>
  <li><spring:message code='log.title.asUsdFltLst'/></li>
 </ul>
 <aside class="title_line">
  <!-- title_line start -->
  <p class="fav">
   <a href="#" class="click_add_on">My menu</a>
  </p>
  <h2><spring:message code='log.title.asUsdFltLst'/></h2>
 </aside>
 <!-- title_line end -->
 <aside class="title_line">
  <!-- title_line start -->
  <h3>Header Info</h3>
  <ul class="right_btns">
   <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue">
      <a id="search"><span class="search"></span><spring:message code='sys.label.search'/></a>
     </p></li>
   </c:if>
   <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
      <li><p class="btn_blue"><a id="pending"><span class="pending"></span>Return</a></p></li>
      <li><p class="btn_blue"><a id="scan"><span class="scan"></span>Serial Check</a></p></li>
      <li><p class="btn_blue"><a id="failed"><span class="failed"></span>Failed</a></p></li>
      <li><p class="btn_blue"><a id="complete"><span class="complete"></span><spring:message code='sal.text.complete'/></a></p></li>
   </c:if>
  </ul>
 </aside>
 <!-- title_line end -->
 <section class="search_table">
  <!-- search_table start -->
  <form id="searchForm" name="searchForm" method="post"
   onsubmit="return false;">
   <table class="type1">
    <!-- table start -->
    <caption>search table</caption>
    <colgroup>
     <col style="width: 140px" />
     <col style="width: *" />
     <col style="width: 140px" />
     <col style="width: *" />
     <col style="width: 140px" />
     <col style="width: *" />
    </colgroup>
    <tbody>
     <tr>
      <th scope="row"><spring:message code='log.label.lctTyp'/> <span class="must">*</span></th>
      <td><select class="w100p" id="searchlocgb" name="searchlocgb" disabled></select>
      </td>
      <th scope="row"><spring:message code='log.head.branch'/></th>
      <td><select class="w100p" id="searchBranch"
       name="searchBranch"></select></td>
      <th scope="row"><spring:message code='log.head.location'/></th>
      <td>
       <select class="w100p" id="searchLoc" name="searchLoc"></select>
      </td>
     </tr>
     <tr>
      <th scope="row"><spring:message code='log.label.lctGrade'/></th>
      <td><select class="w100p" id="searchlocgrade" name="searchlocgrade"></select></td>
      <th scope="row"><spring:message code='service.grid.ASTyp'/></th>
      <td>
         <label><input type="radio" name="asTyp" value="*" checked="checked" /><span>All</span></label>
         <label><input type="radio" name="asTyp" value="as" /><span>AS</span></label>
         <label><input type="radio" name="asTyp" value="ihr" /><span>IHR</span></label>
      </td>
      <th scope="row"><spring:message code='service.grid.ASNo'/></th>
      <td><input type="text" class="w100p" id="searchOder"  name="searchOder"></td>
     </tr>
     <tr>
      <th scope="row"><spring:message code='log.head.customername'/></th>
      <td><input type="text" class="w100p" id="searchCustomer" name="searchCustomer"></td>
      <th scope="row"><spring:message code='log.head.settledate'/></th>
      <td>
       <div class="date_set w100p">
        <p>
         <input id="servicesdt" name="servicesdt" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date">
        </p>
        <span> <spring:message code='log.head.to'/> </span>
        <p>
         <input id="serviceedt" name="serviceedt" type="text" title="Create End Date" placeholder="DD/MM/YYYY" class="j_date ">
        </p>
       </div>
      </td>
      <th scope="row"><spring:message code='sal.text.returnDate'/></th>
      <td>
       <div class="date_set w100p">
        <p>
         <input id="returnsdt" name="returnsdt" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date">
        </p>
        <span> <spring:message code='log.head.to'/> </span>
        <p>
         <input id="returnedt" name="returnedt" type="text" title="Create End Date" placeholder="DD/MM/YYYY" class="j_date">
        </p>
       </div>
      </td>
     </tr>
     <tr>
      <th scope="row"><spring:message code='log.head.materialcode'/></th>
      <td><input type="text" class="w100p" id="searchMaterialCode" name="searchMaterialCode"></td>
      <th scope="row"><spring:message code='log.head.materialtype'/></th>
      <td><select class="w100p" id="searchMaterialType" name="searchMaterialType"></select></td>
      <th scope="row"><spring:message code='sal.title.text.returnStatus'/></th>
      <td><select class="w100p" id="searchComplete" name="searchComplete"></select></td>
     </tr>
     <tr>
      <th scope="row"><spring:message code='service.text.defTyp'/></th>
      <td><select class="w100p" id="searchDefTyp" name="searchDefTyp"></select></td>
      <th scope="row"><spring:message code='service.text.sltCde'/></th>
      <td><select class="w100p" id="searchSltCde" name="searchSltCde"></select></td>
      <th scope="row"></th>
      <td></td>
     </tr>
     <tr>
      <th scope="row"><spring:message code='sales.ProductCategory'/></th>
      <td><select class="w100p" id="searchProdCat" name="searchProdCat"></select></td>
      <th scope="row"><spring:message code='service.text.defCde'/></th>
      <td><select class="w100p" id="searchDefCde" name="searchDefCde"></select></td>
      <th scope="row"></th>
      <td></td>
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
      <c:if test="${PAGE_AUTH.funcUserDefine25 == 'Y'}">
       <li><p class="link_btn type2">
         <a href="#" id="btnHSUsedFilterListing"><spring:message code='log.title.asUsdFltLst'/></a>
        </p></li>
      </c:if>
     </ul>
     <p class="hide_btn">
      <a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a>
     </p>
    </dd>
   </dl>
  </aside>
  <!-- link_btns_wrap end -->
 </section>
 <!-- search_table end -->
 <!-- data body start -->
 <section class="search_result">
  <!-- search_result start -->
  <ul class="right_btns">
   <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
    <li><p class="btn_grid">
      <a id="download"><spring:message code='sys.btn.excel.dw' /></a>
     </p></li>
   </c:if>
  </ul>
  <div id="main_grid_wrap" class="mt10" style="height: 450px"></div>
 </section>
 <!-- search_result end -->
</section>
