
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 24/10/2019  ONGHC  1.0.0          RE-STRUCTURE JSP FILE FORMAT AND REMOVE OTHER SESSION COLUMN
 22/11/2019  ONGHC  1.0.1          ADD CHECKING ON JOB TYPE SELECTION
 -->

<style type="text/css">

/* 커스텀 셀 스타일 */
.my-cell-style {
	background: #FFB2D9;
	font-weight: bold;
	color: #fff;
}

.my-cell-style-sel {
	background: #86E57F;
	font-weight: bold;
	color: #fff;
}

/* 핑크 불가능색 */
.my-row-style {
	background: #FFB2D9;
	font-weight: bold;
	color: #22741C;
}

/* 퍼런색  가능색 */
.my-row-style-Available {
	background: #86E57F;
	font-weight: bold;
	color: #22741C;
}
</style>
<script type="text/javaScript" language="javascript">
  var mAgrid;
  var dAgrid;

  var detailSelRowIndex ;
  var detailSelCellIndex ;

  function fn_doBack(){
    $("#_doAllactionDiv").remove();
  }

  $(document).ready(function() {

    //AUIGrid 그리드를 생성합니다.
    createAllactionAUIGrid();
    createDetailAllactionAUIGrid();

    //doGetCombo('/common/selectCodeList.do', '45', '','comBranchType', 'S' , '');

    AUIGrid.bind(mAgrid, "cellDoubleClick", function(event) {
      fn_selectAllactionDetailListAjax();
    });

    AUIGrid.bind(dAgrid, "cellDoubleClick", function(event) {
      if(event.headerText != '${TYPE}'){
        return ;
      }

      detailSelRowIndex = event.rowIndex;
      detailSelCellIndex  = event.columnIndex;

      setDetailEvent();
    });

    AUIGrid.bind(dAgrid, "cellClick", function( event ) {
      AUIGrid.setRendererProp( dAgrid, event.columnIndex , { styleFunction : "my-cell-style" } );
    });

    // 그룹핑  이벤트  바인딩
    AUIGrid.bind(mAgrid, "grouping", function(event) {
      // 보관된 소팅 정보로 그룹핑 후 소팅 실시함
      if(typeof sortingInfo != "undefined") {
          AUIGrid.setSorting(mAgrid, sortingInfo);
      }
    });


    // 그리드 ready 이벤트 바인딩
    AUIGrid.bind(mAgrid, "ready", function(event) {
      // 최초에 정렬된 채로 그리드 출력 시킴.
      AUIGrid.setSorting(mAgrid, { dataField : "cDate", sortType : 1 });
    });

    // 정렬 이벤트 바인딩
    AUIGrid.bind(mAgrid, "sorting", function(event) {
      // 소팅 정보 보관.
      sortingInfo = event.sortingFields;
    });

    fn_selectAllactionSelectListAjax();
  });

  function setDetailEvent(){
    var selectedItems = AUIGrid.getSelectedItems(mAgrid);

    if(selectedItems.length <= 0 ){
      Common.alert("There Are No selected Items.");
      return ;
    }

    var v_ctId    =selectedItems[0].item.ct;
    var v_sDate =selectedItems[0].item.cDate;

    Common.ajax("GET", "/organization/allocation/selectDetailList", { CT_ID: v_ctId , S_DATE:v_sDate  ,P_DATE :v_sDate }, function(result) {
      AUIGrid.setGridData(dAgrid, result);

      item = {};
      item.memCode =selectedItems[0].item.memCode;
      item.ct=selectedItems[0].item.ct;
      AUIGrid.updateRow(dAgrid, item,0);

      var valArray  =new Array();
      var selectedValue = AUIGrid.getCellValue(dAgrid, detailSelRowIndex, detailSelCellIndex);
      valArray = selectedValue.split("-");
      AUIGrid.setCellValue(dAgrid, detailSelRowIndex ,      detailSelCellIndex , (Number(valArray[0])+1)  +"-"+  Number(valArray[1]) );
      AUIGrid.setSelectionByIndex(dAgrid, detailSelRowIndex,detailSelCellIndex);
    });
  }


  function changeRowStyleFunction() {
    AUIGrid.setProp(mAgrid, "rowStyleFunction", function(rowIndex, item) {

    if(item.dDate == '${S_DATE}')  {
      if('AS'== '${TYPE}'){
        var valArray  =new Array();
        valArray = item.ascnt.split("-");

        if( Number(valArray[0]) ==  Number(valArray[1])   ||  Number(valArray[0])  >=  Number(valArray[1])  ) {
          return "my-row-style";
        } else {
          return "my-row-style-Available";
        }

      } else if('INS'== '${TYPE}'){
        var valArray  =new Array();
        valArray = item.inscnt.split("-");

        if(Number(valArray[0]) == Number(valArray[1])  ||  Number(valArray[0])  >=  Number(valArray[1])  ) {
          return "my-row-style";
        } else {
          return "my-row-style-Available";
        }
      } else if('RTN'== '${TYPE}'){
        var valArray  =new Array();
        valArray = item.rtncnt.split("-");

        if(Number(valArray[0]) == Number(valArray[1])  ||  Number(valArray[0])  >=  Number(valArray[1])   ) {
          return "my-row-style";
        } else {
          return "my-row-style-Available";
        }
      }
    }
    });

    // 변경된 rowStyleFunction 이 적용되도록 그리드 업데이트
    AUIGrid.update(mAgrid);
  };


  //리스트 조회.
  function fn_selectAllactionSelectListAjax () {
    if( '${ORD_ID}' =="") {
      Common.alert("There Are No selected ORDER.");
      return ;
    }
    Common.ajax("GET", "/organization/allocation/selectList",{ORD_ID : '${ORD_ID}' , S_DATE: '${S_DATE}' }, function(result) {
      AUIGrid.setGridData(mAgrid, result);
      changeRowStyleFunction();
    });
  }

  //리스트 조회.
  function  fn_selectAllactionDetailListAjax () {
    var selectedItems = AUIGrid.getSelectedItems(mAgrid);

    if(selectedItems.length <= 0 ){
      Common.alert("There Are No selected Items.");
      return ;
    }

    var v_ctId    =selectedItems[0].item.ct;
    var v_sDate =selectedItems[0].item.cDate;

    Common.ajax("GET", "/organization/allocation/selectDetailList", { CT_ID: v_ctId , S_DATE:v_sDate  ,P_DATE :v_sDate }, function(result) {
      AUIGrid.setGridData(dAgrid, result);

      item = {};
      item.memCode =selectedItems[0].item.memCode;
      item.ct=selectedItems[0].item.ct;
      AUIGrid.updateRow(dAgrid, item,0);
    });
  }

  function createAllactionAUIGrid() {
    var columnLayout = [ { dataField : "reMemCode", headerText   : "CT",    width : 150 ,editable : false    , cellMerge : true},
                         { dataField : "cDate", headerText  : "Date",width : 150 ,editable       : false },
                         { headerText : "Summary",
                           children : [  { dataField : "ascnt",
                                           headerText : "AS",
                                           width : 200 ,
                                           editable : false
                                         },
                                         {
                                           dataField : "inscnt",
                                           headerText : "INS",
                                           width : 200 ,
                                           editable : false
                                         },
                                         {
                                           dataField : "rtncnt",
                                           headerText : "RTN",
                                           width : 200 ,
                                           editable : false
                                         }
                                      ]
                         }
                       ];

    var gridPros = { usePaging : true,  editable: false, fixedColumnCount : 1,  showRowNumColumn : true};
    mAgrid = GridCommon.createAUIGrid("mAgrid_grid_wrap", columnLayout  ,"" ,gridPros);
  }

  /* REQUIRE CHANGES */
  function createDetailAllactionAUIGrid() {
    var columnLayout = [{ dataField : "memCode",
                          headerText  : "CT",
                          width : 100,
                          editable : false,
                          cellMerge : true
                        },
                        { dataField : "ct",
                          headerText  : "",
                          width : 100 ,
                          visible :false
                        },
                        {
                          headerText : "Morning",
                          children : [
                                        {
                                        	headerText : "AS",
                                            width : 100,
                                            children: [
                                                       {
                                                           dataField : "morasstcnt",
                                                           headerText : "A-ST",
                                                           width : 80,
                                                           styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
                                                             var valArray  = new Array();
                                                             valArray = value.split("-");

                                                             if( Number(valArray[0]) > Number(valArray[1])) {
                                                               return "my-cell-style";
                                                             }

                                                             if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
                                                               return "my-cell-style";
                                                             }

                                                             if('AS'== '${TYPE}'){
                                                               return "my-cell-style-sel";
                                                             }

                                                             return null;
                                                           }
                                                       },
                                                       {
                                                           dataField : "morasdskcnt",
                                                           headerText : "A-DSK",
                                                           width : 80,
                                                           styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
                                                             var valArray  = new Array();
                                                             valArray = value.split("-");

                                                             if( Number(valArray[0]) > Number(valArray[1])) {
                                                               return "my-cell-style";
                                                             }

                                                             if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
                                                               return "my-cell-style";
                                                             }

                                                             if('AS'== '${TYPE}'){
                                                               return "my-cell-style-sel";
                                                             }

                                                             return null;
                                                           }
                                                       },
                                                       {
                                                           dataField : "morassmlcnt",
                                                           headerText : "A-SML",
                                                           width : 80,
                                                           styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
                                                             var valArray  = new Array();
                                                             valArray = value.split("-");

                                                             if( Number(valArray[0]) > Number(valArray[1])) {
                                                               return "my-cell-style";
                                                             }

                                                             if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
                                                               return "my-cell-style";
                                                             }

                                                             if('AS'== '${TYPE}'){
                                                               return "my-cell-style-sel";
                                                             }

                                                             return null;
                                                           }
                                                       },
                                                       {
                                                           dataField : "morascnt",
                                                           headerText : "TOTAL(AS)",
                                                           width : 80,
                                                           visible :false,
                                                           styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
                                                             var valArray  = new Array();
                                                             valArray = value.split("-");

//                                                              if( Number(valArray[0]) > Number(valArray[1])) {
//                                                                return "my-cell-style";
//                                                              }

//                                                              if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
//                                                                return "my-cell-style";
//                                                              }

//                                                              if('AS'== '${TYPE}'){
//                                                                return "my-cell-style-sel";
//                                                              }

                                                             return null;
                                                           }
                                                       }
                                          ]
                                        },
                                        {
                                        	headerText : "INS",
                                            width : 100,
                                            children: [
                                                       {
                                                           dataField : "morinsstcnt",
                                                           headerText : "I-ST",
                                                           width : 80,
                                                           styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
                                                             var valArray  = new Array();
                                                             valArray = value.split("-");

                                                             if(Number(valArray[0]) > Number(valArray[1])) {
                                                               return "my-cell-style";
                                                             }

                                                             if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
                                                               return "my-cell-style";
                                                             }

                                                             if('INS'== '${TYPE}'){
                                                               return "my-cell-style-sel";
                                                             }
                                                             return null;
                                                           }
                                                       },
                                                       {
                                                           dataField : "morinsdskcnt",
                                                           headerText : "I-DSK",
                                                           width : 80,
                                                           styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
                                                             var valArray  = new Array();
                                                             valArray = value.split("-");

                                                             if(Number(valArray[0]) > Number(valArray[1])) {
                                                               return "my-cell-style";
                                                             }

                                                             if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
                                                               return "my-cell-style";
                                                             }

                                                             if('INS'== '${TYPE}'){
                                                               return "my-cell-style-sel";
                                                             }
                                                             return null;
                                                           }
                                                       },
                                                       {
                                                           dataField : "morinssmlcnt",
                                                           headerText : "I-SML",
                                                           width : 80,
                                                           styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
                                                             var valArray  = new Array();
                                                             valArray = value.split("-");

                                                             if(Number(valArray[0]) > Number(valArray[1])) {
                                                               return "my-cell-style";
                                                             }

                                                             if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
                                                               return "my-cell-style";
                                                             }

                                                             if('INS'== '${TYPE}'){
                                                               return "my-cell-style-sel";
                                                             }
                                                             return null;
                                                           }
                                                       },
                                                       {
                                                    	   dataField : "morinscnt",
                                                           headerText : "TOTAL(INS)",
                                                           width : 80,
                                                           visible :false,
                                                           styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
                                                             var valArray  = new Array();
                                                             valArray = value.split("-");

//                                                              if(Number(valArray[0]) > Number(valArray[1])) {
//                                                                return "my-cell-style";
//                                                              }

//                                                              if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
//                                                                return "my-cell-style";
//                                                              }

//                                                              if('INS'== '${TYPE}'){
//                                                                return "my-cell-style-sel";
//                                                              }
                                                             return null;
                                                           }
                                                       }
                                            ]
                                        },
                                        {
                                            headerText : "RTN",
                                            width : 100,
                                            children: [
														{
														    dataField : "morrtnstcnt",
														    headerText : "R-ST",
														    width : 80,
														    styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
														      var valArray  =new Array();
														      valArray = value.split("-");

														      if(Number(valArray[0]) > Number(valArray[1])) {
														        return "my-cell-style";
														      }

														      if(Number(valArray[0]) == 0 &&  Number(valArray[1] )==0) {
														        return "my-cell-style";
														      }

														      if('RTN'== '${TYPE}'){
														        return "my-cell-style-sel";
														      }
														      return null;
														    }
														},
														{
                                                            dataField : "morrtndskcnt",
                                                            headerText : "R-DSK",
                                                            width : 80,
                                                            styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
                                                              var valArray  =new Array();
                                                              valArray = value.split("-");

                                                              if(Number(valArray[0]) > Number(valArray[1])) {
                                                                return "my-cell-style";
                                                              }

                                                              if(Number(valArray[0]) == 0 &&  Number(valArray[1] )==0) {
                                                                return "my-cell-style";
                                                              }

                                                              if('RTN'== '${TYPE}'){
                                                                return "my-cell-style-sel";
                                                              }
                                                              return null;
                                                            }
                                                        },
                                                        {
                                                            dataField : "morrtnsmlcnt",
                                                            headerText : "R-SML",
                                                            width : 80,
                                                            styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
                                                              var valArray  =new Array();
                                                              valArray = value.split("-");

                                                              if(Number(valArray[0]) > Number(valArray[1])) {
                                                                return "my-cell-style";
                                                              }

                                                              if(Number(valArray[0]) == 0 &&  Number(valArray[1] )==0) {
                                                                return "my-cell-style";
                                                              }

                                                              if('RTN'== '${TYPE}'){
                                                                return "my-cell-style-sel";
                                                              }
                                                              return null;
                                                            }
                                                        },
                                                       {
                                                    	   dataField : "morrtncnt",
                                                           headerText : "TOTAL(RTN)",
                                                           width : 80,
                                                           visible :false,
                                                           styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
                                                             var valArray  =new Array();
                                                             valArray = value.split("-");

//                                                              if(Number(valArray[0]) > Number(valArray[1])) {
//                                                                return "my-cell-style";
//                                                              }

//                                                              if(Number(valArray[0]) == 0 &&  Number(valArray[1] )==0) {
//                                                                return "my-cell-style";
//                                                              }

//                                                              if('RTN'== '${TYPE}'){
//                                                                return "my-cell-style-sel";
//                                                              }
                                                             return null;
                                                           }
                                                       }
                                             ]
                                         }
                                      ]
                        },
                        {
                          headerText : "After",
                          children : [
										{
										    headerText : "AS",
										    width : 100,
										    children:[
												{
												    dataField : "aftasstcnt",
												    headerText : "A-ST",
												    width : 80,
												    styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
												      var valArray  = new Array();
												      valArray = value.split("-");

												      if(Number(valArray[0]) > Number(valArray[1])) {
												        return "my-cell-style";
												      }
												      if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
												        return "my-cell-style";
												      }
												      if('AS'== '${TYPE}'){
												        return "my-cell-style-sel";
												      }
												      return null;
												    }
												  },
												  {
													    dataField : "aftasdskcnt",
													    headerText : "A-DSK",
													    width : 80,
													    styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
													      var valArray  = new Array();
													      valArray = value.split("-");

													      if(Number(valArray[0]) > Number(valArray[1])) {
													        return "my-cell-style";
													      }
													      if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
													        return "my-cell-style";
													      }
													      if('AS'== '${TYPE}'){
													        return "my-cell-style-sel";
													      }
													      return null;
													    }
													  },
													  {
														    dataField : "aftassmlcnt",
														    headerText : "A-SML",
														    width : 80,
														    styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
														      var valArray  = new Array();
														      valArray = value.split("-");

														      if(Number(valArray[0]) > Number(valArray[1])) {
														        return "my-cell-style";
														      }
														      if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
														        return "my-cell-style";
														      }
														      if('AS'== '${TYPE}'){
														        return "my-cell-style-sel";
														      }
														      return null;
														    }
														  },
														 {
														    dataField : "aftascnt",
														    headerText : "TOTAL(AS)",
														    width : 80,
	                                                        visible :false,
														    styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
														      var valArray  = new Array();
														      valArray = value.split("-");

// 														      if(Number(valArray[0]) > Number(valArray[1])) {
// 														        return "my-cell-style";
// 														      }
// 														      if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
// 														        return "my-cell-style";
// 														      }
// 														      if('AS'== '${TYPE}'){
// 														        return "my-cell-style-sel";
// 														      }
														      return null;
														    }
														  }
										    ]
										},
										{
                                            headerText : "INS",
                                            width : 100,
                                            children:[
														{
														    dataField : "aftinsstcnt",
														    headerText : "I-ST",
														    width : 80,
														    styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
														      var valArray = new Array();
														      valArray = value.split("-");

														      if(Number(valArray[0]) > Number(valArray[1])) {
														        return "my-cell-style";
														      }

														      if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
														        return "my-cell-style";
														      }

														      if('INS'== '${TYPE}'){
														        return "my-cell-style-sel";
														      }

														      return null;
														    }
														  },
														  {
														    dataField : "aftinsdskcnt",
														    headerText : "I-DSK",
														    width : 80,
														    styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
														      var valArray = new Array();
														      valArray = value.split("-");

														      if(Number(valArray[0]) > Number(valArray[1])) {
														        return "my-cell-style";
														      }

														      if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
														        return "my-cell-style";
														      }

														      if('INS'== '${TYPE}'){
														        return "my-cell-style-sel";
														      }

														      return null;
														    }
														  },
														  {
															    dataField : "aftinssmlcnt",
															    headerText : "I-SML",
															    width : 80,
															    styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
															      var valArray = new Array();
															      valArray = value.split("-");

															      if(Number(valArray[0]) > Number(valArray[1])) {
															        return "my-cell-style";
															      }

															      if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
															        return "my-cell-style";
															      }

															      if('INS'== '${TYPE}'){
															        return "my-cell-style-sel";
															      }

															      return null;
															    }
															},
															{
															    dataField : "aftinscnt",
															    headerText : "TOTAL(INS)",
															    width : 80,
		                                                        visible :false,
															    styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
															      var valArray = new Array();
															      valArray = value.split("-");

// 															      if(Number(valArray[0]) > Number(valArray[1])) {
// 															        return "my-cell-style";
// 															      }

// 															      if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
// 															        return "my-cell-style";
// 															      }

// 															      if('INS'== '${TYPE}'){
// 															        return "my-cell-style-sel";
// 															      }

															      return null;
															    }
															  }
                                            ]
                                        },
                                        {
                                            headerText : "RTN",
                                            width : 100,
                                            children:[
													{
													    dataField : "aftrtnstcnt",
													    headerText : "R-ST",
													    width : 80,
													    styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
													      var valArray = new Array();
													      valArray = value.split("-");

													      if(Number(valArray[0]) >  Number(valArray[1])) {
													        return "my-cell-style";
													      }

													      if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
													        return "my-cell-style";
													      }

													      if('RTN'== '${TYPE}'){
													        return "my-cell-style-sel";
													      }

													      return null;
													    }
													  },
													  {
														    dataField : "aftrtndskcnt",
														    headerText : "R-DSK",
														    width : 80,
														    styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
														      var valArray = new Array();
														      valArray = value.split("-");

														      if(Number(valArray[0]) >  Number(valArray[1])) {
														        return "my-cell-style";
														      }

														      if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
														        return "my-cell-style";
														      }

														      if('RTN'== '${TYPE}'){
														        return "my-cell-style-sel";
														      }

														      return null;
														    }
														  },
														  {
															    dataField : "aftrtnsmlcnt",
															    headerText : "R-SML",
															    width : 80,
															    styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
															      var valArray = new Array();
															      valArray = value.split("-");

															      if(Number(valArray[0]) >  Number(valArray[1])) {
															        return "my-cell-style";
															      }

															      if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
															        return "my-cell-style";
															      }

															      if('RTN'== '${TYPE}'){
															        return "my-cell-style-sel";
															      }

															      return null;
															    }
															  },
                                                            {
					                                          dataField : "aftrtncnt",
					                                          headerText : "TOTAL(RTN)",
					                                          width : 80,
					                                          visible :false,
					                                          styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
					                                            var valArray = new Array();
					                                            valArray = value.split("-");

// 					                                            if(Number(valArray[0]) >  Number(valArray[1])) {
// 					                                              return "my-cell-style";
// 					                                            }

// 					                                            if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
// 					                                              return "my-cell-style";
// 					                                            }

// 					                                            if('RTN'== '${TYPE}'){
// 					                                              return "my-cell-style-sel";
// 					                                            }

					                                            return null;
					                                          }
					                                        }
                                            ]
                                        }
                                     ]
                            },
                            {
                                headerText : "Evening",
                                children : [
                                            {
                                            	 headerText : "AS",
                                                 width : 100,
                                                 children: [
														{
														    dataField : "evnasstcnt",
														    headerText : "A-ST",
														    width : 80,
														    styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
														      var valArray  = new Array();
														      valArray = value.split("-");

														      if(Number(valArray[0]) >  Number(valArray[1])) {
														        return "my-cell-style";
														      }

														      if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
														        return "my-cell-style";
														      }

														      if('AS'== '${TYPE}'){
														        return "my-cell-style-sel";
														      }
														      return null;
														    }
														  },
														  {
															    dataField : "evnasdskcnt",
															    headerText : "A-DSK",
															    width : 80,
															    styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
															      var valArray  = new Array();
															      valArray = value.split("-");

															      if(Number(valArray[0]) >  Number(valArray[1])) {
															        return "my-cell-style";
															      }

															      if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
															        return "my-cell-style";
															      }

															      if('AS'== '${TYPE}'){
															        return "my-cell-style-sel";
															      }
															      return null;
															    }
															  },
															  {
																    dataField : "evnassmlcnt",
																    headerText : "A-SML",
																    width : 80,
																    styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
																      var valArray  = new Array();
																      valArray = value.split("-");

																      if(Number(valArray[0]) >  Number(valArray[1])) {
																        return "my-cell-style";
																      }

																      if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
																        return "my-cell-style";
																      }

																      if('AS'== '${TYPE}'){
																        return "my-cell-style-sel";
																      }
																      return null;
																    }
																  },
																{
																    dataField : "evnascnt",
																    headerText : "TOTAL(AS)",
																    width : 80,
		                                                            visible :false,
																    styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
																      var valArray  = new Array();
																      valArray = value.split("-");

// 																      if(Number(valArray[0]) >  Number(valArray[1])) {
// 																        return "my-cell-style";
// 																      }

// 																      if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
// 																        return "my-cell-style";
// 																      }

// 																      if('AS'== '${TYPE}'){
// 																        return "my-cell-style-sel";
// 																      }
																      return null;
																    }
																  }
                                                            ]
                                            },
                                            {
                                            	 headerText : "INS",
                                                 width : 100,
                                                 children: [
												{
												    dataField : "evninsstcnt",
												    headerText : "I-ST",
												    width : 80,
												    styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
												        var valArray  = new Array();
												        valArray = value.split("-");

												        if(Number(valArray[0]) > Number(valArray[1])) {
												          return "my-cell-style";
												        }

												        if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
												            return "my-cell-style";
												          }

												        if('INS'== '${TYPE}'){
												          return "my-cell-style-sel";
												        }

												        return null;
												      }
												    },
												    {
												        dataField : "evninsdskcnt",
												        headerText : "I-DSK",
												        width : 80,
												        styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
												            var valArray  = new Array();
												            valArray = value.split("-");

												            if(Number(valArray[0]) > Number(valArray[1])) {
												              return "my-cell-style";
												            }

												            if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
												                return "my-cell-style";
												              }

												            if('INS'== '${TYPE}'){
												              return "my-cell-style-sel";
												            }

												            return null;
												          }
												        },
												        {
												            dataField : "evninsdskcnt",
												            headerText : "I-DSK",
												            width : 80,
												            styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
												                var valArray  = new Array();
												                valArray = value.split("-");

												                if(Number(valArray[0]) > Number(valArray[1])) {
												                  return "my-cell-style";
												                }

												                if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
												                    return "my-cell-style";
												                  }

												                if('INS'== '${TYPE}'){
												                  return "my-cell-style-sel";
												                }

												                return null;
												              }
												            },
                                                            {
                                                            	dataField : "evninscnt",
                                                                headerText : "TOTAL(INS)",
                                                                width : 80,
                                                                visible :false,
                                                                styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
                                                                    var valArray  = new Array();
                                                                    valArray = value.split("-");

//                                                                     if(Number(valArray[0]) > Number(valArray[1])) {
//                                                                       return "my-cell-style";
//                                                                     }

//                                                                     if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
//                                                                         return "my-cell-style";
//                                                                       }

//                                                                     if('INS'== '${TYPE}'){
//                                                                       return "my-cell-style-sel";
//                                                                     }

                                                                    return null;
                                                                  }
                                                                }
                                                            ]
                                            },
                                            {
                                                headerText : "RTN",
                                                width : 100,
                                                children: [
																{
																    dataField : "evnrtnstcnt",
																    headerText : "R-ST",
																    width : 80,
																    styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
																      var valArray  =new Array();
																      valArray = value.split("-");

																      if(Number(valArray[0]) >  Number(valArray[1])) {
																        return "my-cell-style";
																      }

																      if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
																        return "my-cell-style";
																      }

																      if('RTN'== '${TYPE}'){
																        return "my-cell-style-sel";
																      }
																      return null;
																    }
																},
															    {
															        dataField : "evnrtndskcnt",
															        headerText : "R-DSK",
															        width : 80,
															        styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
															          var valArray  =new Array();
															          valArray = value.split("-");

															          if(Number(valArray[0]) >  Number(valArray[1])) {
															            return "my-cell-style";
															          }

															          if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
															            return "my-cell-style";
															          }

															          if('RTN'== '${TYPE}'){
															            return "my-cell-style-sel";
															          }
															          return null;
															        }
															    },
															    {
															        dataField : "evnrtnsmlcnt",
															        headerText : "R-SML",
															        width : 80,
															        styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
															          var valArray  =new Array();
															          valArray = value.split("-");

															          if(Number(valArray[0]) >  Number(valArray[1])) {
															            return "my-cell-style";
															          }

															          if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
															            return "my-cell-style";
															          }

															          if('RTN'== '${TYPE}'){
															            return "my-cell-style-sel";
															          }
															          return null;
															        }
															    },
																{
																	dataField : "evnrtncnt",
																    headerText : "TOTAL(RTN)",
																    width : 80,
		                                                            visible :false,
																    styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
																      var valArray  =new Array();
																      valArray = value.split("-");

// 																      if(Number(valArray[0]) >  Number(valArray[1])) {
// 																        return "my-cell-style";
// 																      }

// 																      if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
// 																        return "my-cell-style";
// 																      }

// 																      if('RTN'== '${TYPE}'){
// 																        return "my-cell-style-sel";
// 																      }
																      return null;
																    }
																}
                                                           ]
                                           },
                                   ]
                            },
                            {
                              headerText : "Other Session",
                              visible : false,
                              children : [
                                            {
                                             headerTest: "AS",
                                             visible : false,
                                             children:[
														{
														    dataField : "othasstcnt",
														    headerText : "ST",
														    width : 80,
														    visible : false,
														    styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
														      return null;
														    }
														},
														{
														    dataField : "othasdskcnt",
														    headerText : "DSK",
														    width : 80,
														    visible : false,
														    styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
														      return null;
														    }
														},
														{
														    dataField : "othassmlcnt",
														    headerText : "SML",
														    width : 80,
														    visible : false,
														    styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
														      return null;
														    }
														},
                                                       {
                                                    	   dataField : "othascnt",
                                                           headerText : "TOTAL(AS)",
                                                           width : 80,
                                                           visible : false,
                                                           styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
                                                             return null;
                                                           }
                                                       }
                                                  ]
                                            },
                                            {
                                            	headerText:"INS",
                                                visible : false,
                                            	children:[
															{
															    dataField : "othinsstcnt",
															    headerText : "ST",
															    width : 80,
															    visible : false,
															    styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
															      return null;
															    }
															},
															{
															    dataField : "othinsdskcnt",
															    headerText : "DSK",
															    width : 80,
															    visible : false,
															    styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
															      return null;
															    }
															},
															{
															    dataField : "othinssmlcnt",
															    headerText : "SML",
															    width : 80,
															    visible : false,
															    styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
															      return null;
															    }
															},
															{
																dataField : "othinscnt",
															    headerText : "INS",
															    width : 80,
															    visible : false,
															    styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
															      return null;
															      }
															}
                                            	          ]
                                            },
                                            {
                                            	headerText:"INS",
                                                visible : false,
                                                children:[
                                                            {
                                                                dataField : "othrtnstcnt",
                                                                headerText : "ST",
                                                                width : 80,
                                                                visible : false,
                                                                styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
                                                                  return null;
                                                                }
                                                            },
                                                            {
                                                                dataField : "othrtndskcnt",
                                                                headerText : "DSK",
                                                                width : 80,
                                                                visible : false,
                                                                styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
                                                                  return null;
                                                                }
                                                            },
                                                            {
                                                                dataField : "othrtnsmlcnt",
                                                                headerText : "SML",
                                                                width : 80,
                                                                visible : false,
                                                                styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
                                                                  return null;
                                                                }
                                                            },
                                                            {
                                                            	dataField : "othrtncnt",
                                                                headerText : "RTN",
                                                                width : 80,
                                                                visible : false,
                                                                styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
                                                                  return null;
                                                                }
                                                            }
                                                          ]
                                            }
                                         ]
                            },
                           {
                            headerText : "Summary",
                            children : [
                                          {
                                            headerText : "AS",
                                            width : 100,
                                            children : [
                                                        {
                                                            dataField : "sumasstcnt",
                                                            headerText : "ST",
                                                            width : 80,
                                                            styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
                                                              var valArray  = new Array();
                                                              valArray = value.split("-");
                                                              if(Number(valArray[0]) > Number(valArray[1])) {
                                                                  return "my-cell-style";
                                                                }
                                                                if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
                                                                  return "my-cell-style";
                                                                }
                                                              return null;
                                                             }
                                                        },
                                                        {
                                                            dataField : "sumasdskcnt",
                                                            headerText : "DSK",
                                                            width : 80,
                                                            styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
                                                              var valArray  = new Array();
                                                              valArray = value.split("-");
                                                              if(Number(valArray[0]) > Number(valArray[1])) {
                                                                  return "my-cell-style";
                                                                }
                                                                if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
                                                                  return "my-cell-style";
                                                                }
                                                              return null;
                                                             }
                                                        },
                                                        {
                                                            dataField : "sumassmlcnt",
                                                            headerText : "SML",
                                                            width : 80,
                                                            styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
                                                              var valArray  = new Array();
                                                              valArray = value.split("-");
                                                              if(Number(valArray[0]) > Number(valArray[1])) {
                                                                  return "my-cell-style";
                                                                }
                                                                if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
                                                                  return "my-cell-style";
                                                                }
                                                              return null;
                                                             }
                                                        },
                                                          {
                                                              dataField : "sumascnt",
                                                              headerText : "TOTAL(AS)",
                                                              width : 80,
                                                              visible :false,
                                                              styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
                                                                var valArray  = new Array();
                                                                valArray = value.split("-");
                                                                if(Number(valArray[0]) > Number(valArray[1])) {
                                                                    return "my-cell-style";
                                                                  }
                                                                  if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
                                                                    return "my-cell-style";
                                                                  }
                                                                return null;
                                                               }
                                                          }
                                            ]
                                          },
                                          {
                                              headerText : "INS",
                                              width : 100,
                                              children : [
                                                          {
                                                              dataField : "suminsstcnt",
                                                              headerText : "ST",
                                                              width : 80,
                                                              styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
                                                                var valArray  = new Array();
                                                                valArray = value.split("-");
                                                                if(Number(valArray[0]) > Number(valArray[1])) {
                                                                  return "my-cell-style";
                                                                }
                                                                if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
                                                                  return "my-cell-style";
                                                                }
                                                                return null;
                                                               }
                                                          },
                                                          {
                                                              dataField : "suminsdskcnt",
                                                              headerText : "DSK",
                                                              width : 80,
                                                              styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
                                                                var valArray  = new Array();
                                                                valArray = value.split("-");
                                                                if(Number(valArray[0]) > Number(valArray[1])) {
                                                                  return "my-cell-style";
                                                                }
                                                                if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
                                                                  return "my-cell-style";
                                                                }
                                                                return null;
                                                               }
                                                          },
                                                          {
                                                              dataField : "suminssmlcnt",
                                                              headerText : "SML",
                                                              width : 80,
                                                              styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
                                                                var valArray  = new Array();
                                                                valArray = value.split("-");
                                                                if(Number(valArray[0]) > Number(valArray[1])) {
                                                                  return "my-cell-style";
                                                                }
                                                                if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
                                                                  return "my-cell-style";
                                                                }
                                                                return null;
                                                               }
                                                          },
                                                            {
                                                                dataField : "suminscnt",
                                                                headerText : "TOTAL(INS)",
                                                                width : 80,
                                                                visible :false,
                                                                styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
                                                                  var valArray  = new Array();
                                                                  valArray = value.split("-");
                                                                  if(Number(valArray[0]) > Number(valArray[1])) {
                                                                    return "my-cell-style";
                                                                  }
                                                                  if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
                                                                    return "my-cell-style";
                                                                  }
                                                                  return null;
                                                                 }
                                                            }
                                              ]
                                          },
                                          {
                                              headerText : "RTN",
                                              width : 100,
                                              children : [
                                                          {
                                                              dataField : "sumrtnstcnt",
                                                              headerText : "ST",
                                                              width : 80,
                                                              styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
                                                                var valArray  = new Array();
                                                                valArray = value.split("-");
                                                                if(Number(valArray[0]) > Number(valArray[1])) {
                                                                  return "my-cell-style";
                                                                }
                                                                if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
                                                                  return "my-cell-style";
                                                                }
                                                                return null;
                                                               }
                                                          },
                                                          {
                                                              dataField : "sumrtndskcnt",
                                                              headerText : "DSK",
                                                              width : 80,
                                                              styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
                                                                var valArray  = new Array();
                                                                valArray = value.split("-");
                                                                if(Number(valArray[0]) > Number(valArray[1])) {
                                                                  return "my-cell-style";
                                                                }
                                                                if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
                                                                  return "my-cell-style";
                                                                }
                                                                return null;
                                                               }
                                                          },
                                                          {
                                                              dataField : "sumrtnsmlcnt",
                                                              headerText : "SML",
                                                              width : 80,
                                                              styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
                                                                var valArray  = new Array();
                                                                valArray = value.split("-");
                                                                if(Number(valArray[0]) > Number(valArray[1])) {
                                                                  return "my-cell-style";
                                                                }
                                                                if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
                                                                  return "my-cell-style";
                                                                }
                                                                return null;
                                                               }
                                                          },
                                                            {
                                                                dataField : "sumrtncnt",
                                                                headerText : "TOTAL(RTN)",
                                                                width : 80,
                                                                visible :false,
                                                                styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
                                                                  var valArray  = new Array();
                                                                  valArray = value.split("-");
                                                                  if(Number(valArray[0]) > Number(valArray[1])) {
                                                                    return "my-cell-style";
                                                                  }
                                                                  if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
                                                                    return "my-cell-style";
                                                                  }
                                                                  return null;
                                                                 }
                                                            }
                                              ]
                                          }
                                       ]
                          },
                        ];

    var gridPros = { usePaging : true,  editable: false, fixedColumnCount : 1,  showRowNumColumn : true};
    dAgrid = GridCommon.createAUIGrid("dAgrid_grid_wrap", columnLayout  ,"" ,gridPros);
    AUIGrid.bind(dAgrid, ["cellEditEnd", "cellEditCancel"], auiCellEditingHandler);
  }

  function fn_AllocationConfirm(){
    var selectedItemsMain = AUIGrid.getSelectedItems(mAgrid);
    var selectedItems = AUIGrid.getSelectedItems(dAgrid);

    if(selectedItems.length <= 0 ){
    	Common.alert("<spring:message code='service.msg.NoRcd'/>");
      return ;
    }

    var str = "";
    var i, rowItem, rowInfoObj, dataField;

    for(i=0; i<selectedItems.length; i++) {
      rowInfoObj = selectedItems[i];
      var typeValue = '${TYPE}';

      if (rowInfoObj.headerText.charAt(0) != typeValue.charAt(0)){
        Common.alert("<b><font color='red'>" + rowInfoObj.headerText + "</font></b> column are selected. Please select highlighted <b><font color='green'>" + '${TYPE}' + "</font></b> column.");
        return ;
      }

      var valArray  =new Array();
      valArray = rowInfoObj.value.split("-");

      if(rowInfoObj.dataField =="sumascnt" ||  rowInfoObj.dataField =="suminscnt" ||  rowInfoObj.dataField =="sumrtncnt"   ){
        Common.alert("Summary can not be selected.");
        return ;
      }

      if(rowInfoObj.dataField =="morascnt" ||  rowInfoObj.dataField =="morinscnt" ||  rowInfoObj.dataField =="morrtncnt"
    		  || rowInfoObj.dataField =="aftascnt" || rowInfoObj.dataField =="aftinscnt" || rowInfoObj.dataField =="aftrtncnt"
    		  || rowInfoObj.dataField =="evnascnt" || rowInfoObj.dataField =="evninscnt" || rowInfoObj.dataField =="evnrtncnt"){
          Common.alert("Total value can not be selected.");
          return ;
      }

      if(rowInfoObj.dataField !="othascnt"  &&   rowInfoObj.dataField !="othinscnt" && rowInfoObj.dataField !="othrtncnt"  ){
         if(Number(valArray[1]) == "0" ){
           Common.alert("CAPA is not registered in the selected session.");
           return ;
         }

         if(Number(valArray[0]) >=  Number(valArray[1]) ){
           Common.alert("The selected session has already been completed. Please select another session ");
           return ;
         }
      }
    }

    var sessionText;
    var sessionCode;
    var sessionSegmentType;
    if(rowInfoObj.dataField =="morascnt" ||  rowInfoObj.dataField =="morinscnt" ||  rowInfoObj.dataField =="morrtncnt" ||
    		rowInfoObj.dataField =="morasstcnt" ||  rowInfoObj.dataField =="morasdskcnt" ||rowInfoObj.dataField =="morassmlcnt" ||
    		rowInfoObj.dataField =="morinsstcnt" ||  rowInfoObj.dataField =="morinsdskcnt" ||  rowInfoObj.dataField =="morinssmlcnt" ||
    		rowInfoObj.dataField =="morrtnstcnt" || rowInfoObj.dataField =="morrtndskcnt" || rowInfoObj.dataField =="morrtnsmlcnt" ){
      sessionCode ="M";
    }

    if(rowInfoObj.dataField =="othascnt" ||  rowInfoObj.dataField =="othinscnt" ||  rowInfoObj.dataField =="othrtncnt" ||
    		rowInfoObj.dataField =="othasstcnt" ||  rowInfoObj.dataField =="othasdskcnt" ||  rowInfoObj.dataField =="othassmlcnt" ||
    		rowInfoObj.dataField =="othinsstcnt" ||  rowInfoObj.dataField =="othinsdskcnt" || rowInfoObj.dataField =="othinssmlcnt" ||
    		rowInfoObj.dataField =="othrtnstcnt" || rowInfoObj.dataField =="othrtndskcnt" || rowInfoObj.dataField =="othrtnsmlcnt" ){
        sessionCode ="O";
    }

    if(rowInfoObj.dataField =="evnascnt" ||  rowInfoObj.dataField =="evninscnt" ||  rowInfoObj.dataField =="evnrtncnt" ||
    		rowInfoObj.dataField =="evnasstcnt" ||  rowInfoObj.dataField =="evnasdskcnt" ||  rowInfoObj.dataField =="evnassmlcnt" ||
    		rowInfoObj.dataField =="evninsstcnt" ||  rowInfoObj.dataField =="evninsdskcnt" || rowInfoObj.dataField =="evninssmlcnt" ||
    		rowInfoObj.dataField =="evnrtnstcnt" || rowInfoObj.dataField =="evnrtndskcnt" || rowInfoObj.dataField =="evnrtnsmlcnt" ){
        sessionCode ="E";
    }

    if(rowInfoObj.dataField =="aftascnt" ||  rowInfoObj.dataField =="aftinscnt" ||  rowInfoObj.dataField =="aftrtncnt" ||
    		rowInfoObj.dataField =="aftasstcnt" ||  rowInfoObj.dataField =="aftasdskcnt" ||rowInfoObj.dataField =="aftassmlcnt" ||
    		rowInfoObj.dataField =="aftinsstcnt" ||  rowInfoObj.dataField =="aftinsdskcnt" ||  rowInfoObj.dataField =="aftinssmlcnt" ||
    		rowInfoObj.dataField =="aftrtnstcnt" || rowInfoObj.dataField =="aftrtndskcnt" || rowInfoObj.dataField =="aftrtnsmlcnt"){
        sessionCode ="A";
    }

    if(rowInfoObj.dataField =="morasstcnt" || rowInfoObj.dataField =="morinsstcnt" || rowInfoObj.dataField =="morrtnstcnt" ||
            rowInfoObj.dataField =="othasstcnt" ||rowInfoObj.dataField =="othinsstcnt" ||rowInfoObj.dataField =="othrtnstcnt" ||
            rowInfoObj.dataField =="evnasstcnt" ||rowInfoObj.dataField =="evninsstcnt" ||rowInfoObj.dataField =="evnrtnstcnt" ||
            rowInfoObj.dataField =="aftasstcnt" ||rowInfoObj.dataField =="aftinsstcnt" ||rowInfoObj.dataField =="aftrtnstcnt") {
    	   sessionSegmentType = 'ST';
    	}

    if(rowInfoObj.dataField =="morasdskcnt" || rowInfoObj.dataField =="morinsdskcnt" || rowInfoObj.dataField =="morrtndskcnt" ||
            rowInfoObj.dataField =="othasdskcnt" ||rowInfoObj.dataField =="othinsdskcnt" ||rowInfoObj.dataField =="othrtndskcnt" ||
            rowInfoObj.dataField =="evnasdskcnt" ||rowInfoObj.dataField =="evninsdskcnt" ||rowInfoObj.dataField =="evnrtndskcnt" ||
            rowInfoObj.dataField =="aftasdskcnt" ||rowInfoObj.dataField =="aftinsdskcnt" ||rowInfoObj.dataField =="aftrtndskcnt") {
        sessionSegmentType = 'DSK';
    }

    if(rowInfoObj.dataField =="morassmlcnt" || rowInfoObj.dataField =="morinssmlcnt" || rowInfoObj.dataField =="morrtnsmlcnt" ||
            rowInfoObj.dataField =="othassmlcnt" ||rowInfoObj.dataField =="othinssmlcnt" ||rowInfoObj.dataField =="othrtnsmlcnt" ||
            rowInfoObj.dataField =="evnassmlcnt" ||rowInfoObj.dataField =="evninssmlcnt" ||rowInfoObj.dataField =="evnrtnsmlcnt" ||
            rowInfoObj.dataField =="aftassmlcnt" ||rowInfoObj.dataField =="aftinssmlcnt" ||rowInfoObj.dataField =="aftrtnsmlcnt") {
        sessionSegmentType = 'SML';
    }

    if('${CallBackFun}' !=''){
        rtnObj = new Object();
        rtnObj.sessionCode = sessionCode;
        rtnObj.sessionSegmentType = sessionSegmentType;
        rtnObj.memCode = selectedItems[0].item.memCode;
        rtnObj.ct = selectedItems[0].item.ct;
        rtnObj.ctSubGrp = selectedItems[0].item.ctSubGrp;
        rtnObj.dDate = selectedItemsMain[0].item.dDate;
        rtnObj.brnchId = selectedItemsMain[0].item.brnchId;

        $("#_doAllactionDiv").remove();
        eval(${CallBackFun}(rtnObj));

    } else {
      $("#CTSSessionCode").val(sessionCode);
      $("#CTSSessionSegmentType").val(sessionSegmentType);
      $("#CTCode").val(selectedItems[0].item.memCode);
      $("#CTID").val(selectedItems[0].item.ct);
      $("#CTgroup").val(selectedItems[0].item.ctSubGrp);
      $("#appDate").val(selectedItemsMain[0].item.dDate);
      $("#branchDSC").val(selectedItemsMain[0].item.brnchId);

      $("#_doAllactionDiv").remove();
    }
  }

  function fn_doAllocationResult(){}
  function auiCellEditingHandler(event) {}
</script>

<div id="popup_wrap" class="popup_wrap">
	<!-- popup_wrap start -->
	<header class="pop_header">
		<!-- pop_header start -->
		<h1>CT Allocation Matrix</h1>
		<ul class="right_opt">
			<li><p class="btn_blue2">
					<a href="#">CLOSE</a>
				</p></li>
		</ul>
	</header>
	<!-- pop_header end -->
	<section class="pop_body">
		<!-- pop_body start -->
		<section class="search_result mt30">
			<!-- search_result start -->
			<aside class="title_line">
				<!-- title_line start -->
				<h4>Information Display</h4>
			</aside>
			<!-- title_line end -->
			<article class="grid_wrap">
				<!-- grid_wrap start -->
				<div id="mAgrid_grid_wrap"
					style="width: 100%; height: 300px; margin: 0 auto;"></div>
			</article>
			<!-- grid_wrap end -->
			<aside class="title_line">
				<!-- title_line start -->
				<h4>Detail Information</h4>
			</aside>
			<!-- title_line end -->
			<article class="grid_wrap">
				<!-- grid_wrap start -->
				<div id="dAgrid_grid_wrap"
					style="width: 100%; height: 200px; margin: 0 auto;"></div>
			</article>
			<!-- grid_wrap end -->
		</section>
		<!-- search_result end -->
		<input type='hidden' value='${TYPE}' />
		<ul class="center_btns mt20">
			<li><p class="btn_blue2">
					<a href="#" onclick="javascript:fn_AllocationConfirm()">Allocation
						Confirm</a>
				</p></li>
		</ul>
	</section>
	<!-- pop_body end -->
</div>
<!-- popup_wrap end -->
<script>


</script>
