<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
  <%@ include file="/WEB-INF/tiles/view/common.jsp" %>

    <style type="text/css">
      /* 칼럼 스타일 전체 재정의 */
      .aui-grid-left-column {
        text-align: left;
      }

      .write-active-style {
        background: #ddedde;
      }

      .my-inactive-style {
        background: #efcefc;
      }
    </style>
    <script type="text/javaScript">

var gAddRowCnt = 0;
var gOrgList =   ["ORG", "LOG","SAL", "PAY", "SVC", "CCR", "CMM", "SYS", "MIS","SCM","FCM","HCT","RND","SUP"];
var keyValueList = [];

var TransColumnLayout =
    [
        {
            dataField : "funcView",
            headerText : "<spring:message code='sys.progmanagement.grid1.VIEW'/>",
            width : 55,
            renderer :
            {
                type : "CheckBoxEditRenderer",
                showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                checkValue : "Y", // true, false 인 경우가 기본
                unCheckValue : "N",
                // 체크박스 Visible 함수
                visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField)
                 {
                   if(item.funcView == "Y")
                   {
                    return true; // checkbox visible
                   }

                   return true;
                 }
            },  //renderer

        }, {
            dataField : "funcChng",
            headerText : "<spring:message code='sys.progmanagement.grid1.CHANGE'/>",
            width : 70,
            editable : true,
            renderer :
            {
                type : "CheckBoxEditRenderer",
                showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                checkValue : "Y", // true, false 인 경우가 기본
                unCheckValue : "N",
                // 체크박스 Visible 함수
                visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField)
                 {
                   if(item.funcChng == "Y")
                   {
                    return true; // checkbox visible
                   }

                   return true;
                 }
            }  //renderer
        }, {
            dataField : "funcPrt",
            headerText : "<spring:message code='sys.progmanagement.grid1.PRINT'/>",
            width : 55,
            editable : true,
            renderer :
            {
                type : "CheckBoxEditRenderer",
                showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                checkValue : "Y", // true, false 인 경우가 기본
                unCheckValue : "N",
                // 체크박스 Visible 함수
                visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField)
                 {
                   if(item.funcPrt == "Y")
                   {
                    return true; // checkbox visible
                   }

                   return true;
                 }
            }  //renderer
        }, {
            headerText : "<spring:message code='sys.progmanagement.grid1.User_Define_1'/>",
              children : [ {
                              dataField : "funcUserDfn1",
                              headerText : "<spring:message code='sys.progmanagement.grid1.Checked'/>",
                              editable : true,
                              renderer :
                              {
                                  type : "CheckBoxEditRenderer",
                                  showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                                  editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                                  checkValue : "Y", // true, false 인 경우가 기본
                                  unCheckValue : "N",
                                  // 체크박스 Visible 함수
                                  visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField)
                                   {
                                     if(item.funcUserDfn1 == "Y")
                                     {
                                      return true; // checkbox visible
                                     }
                                     return true;
                                   }
                              }  //renderer
                            }, {
                              dataField : "descUserDfn1",
                              headerText : "<spring:message code='sys.progmanagement.grid1.Desc1'/>",
                              cellMerge: true,
                            }
                         ]
          } , {
              headerText : "<spring:message code='sys.progmanagement.grid1.User_Define_2'/>",
                children : [ {
                                dataField : "funcUserDfn2",
                                headerText : "<spring:message code='sys.progmanagement.grid1.Checked'/>",
                                editable : true,
                                renderer :
                                {
                                    type : "CheckBoxEditRenderer",
                                    showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                                    editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                                    checkValue : "Y", // true, false 인 경우가 기본
                                    unCheckValue : "N",
                                    // 체크박스 Visible 함수
                                    visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField)
                                     {
                                       if(item.funcUserDfn2 == "Y")
                                       {
                                        return true; // checkbox visible
                                       }

                                       return true;
                                     }
                                }  //renderer
                              }, {
                                dataField : "descUserDfn2",
                                headerText : "<spring:message code='sys.progmanagement.grid1.Desc2'/>",
                              }
                           ],
          width : 150
            }, {
                headerText : "<spring:message code='sys.progmanagement.grid1.User_Define_3'/>",
                  children : [ {
                                  dataField : "funcUserDfn3",
                                  headerText : "<spring:message code='sys.progmanagement.grid1.Checked'/>",
                                  editable : true,
                                  renderer :
                                  {
                                      type : "CheckBoxEditRenderer",
                                      showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                                      editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                                      checkValue : "Y", // true, false 인 경우가 기본
                                      unCheckValue : "N",
                                      // 체크박스 Visible 함수
                                      visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField)
                                       {
                                         if(item.funcUserDfn3 == "Y")
                                         {
                                          return true; // checkbox visible
                                         }

                                         return true;
                                       }
                                  }  //renderer
                                }, {
                                  dataField : "descUserDfn3",
                                  headerText : "<spring:message code='sys.progmanagement.grid1.Desc3'/>",
                                }
                             ],
                             width : 150
              }, {
                  headerText : "<spring:message code='sys.progmanagement.grid1.User_Define_4'/>",
                    children : [ {
                                    dataField : "funcUserDfn4",
                                    headerText : "<spring:message code='sys.progmanagement.grid1.Checked'/>",
                                    editable : true,
                                    renderer :
                                    {
                                        type : "CheckBoxEditRenderer",
                                        showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                                        editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                                        checkValue : "Y", // true, false 인 경우가 기본
                                        unCheckValue : "N",
                                        // 체크박스 Visible 함수
                                        visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField)
                                         {
                                           if(item.funcUserDfn4 == "Y")
                                           {
                                            return true; // checkbox visible
                                           }

                                           return true;
                                         }
                                    }  //renderer
                                  }, {
                                    dataField : "descUserDfn4",
                                    headerText : "<spring:message code='sys.progmanagement.grid1.Desc4'/>",
                                  }
                               ],
                               width : 150
                },
                {
                    headerText : "<spring:message code='sys.progmanagement.grid1.User_Define_5'/>",
                      children : [ {
                                      dataField : "funcUserDfn5",
                                      headerText : "<spring:message code='sys.progmanagement.grid1.Checked'/>",
                                      editable : true,
                                      renderer :
                                      {
                                          type : "CheckBoxEditRenderer",
                                          showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                                          editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                                          checkValue : "Y", // true, false 인 경우가 기본
                                          unCheckValue : "N",
                                          // 체크박스 Visible 함수
                                          visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField)
                                           {
                                             if(item.funcUserDfn5 == "Y")
                                             {
                                              return true; // checkbox visible
                                             }

                                             return true;
                                           }
                                      }  //renderer
                                    }
                                  , {
                                      dataField : "descUserDfn5",
                                      headerText : "<spring:message code='sys.progmanagement.grid1.Desc5'/>",
                                    }
                                 ],
                                 width : 150
                },



                ///////////////////////////////////////////////////////////////////


                {
                    headerText : "<spring:message code='sys.progmanagement.grid1.User_Define_6'/>",
                      children : [ {
                                      dataField : "funcUserDfn6",
                                      headerText : "<spring:message code='sys.progmanagement.grid1.Checked'/>",
                                      editable : true,
                                      renderer :
                                      {
                                          type : "CheckBoxEditRenderer",
                                          showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                                          editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                                          checkValue : "Y", // true, false 인 경우가 기본
                                          unCheckValue : "N",
                                          // 체크박스 Visible 함수
                                          visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField)
                                           {
                                             if(item.funcUserDfn6 == "Y")
                                             {
                                              return true; // checkbox visible
                                             }

                                             return true;
                                           }
                                      }  //renderer
                                    }
                                  , {
                                      dataField : "descUserDfn6",
                                      headerText : "<spring:message code='sys.progmanagement.grid1.Desc6'/>",
                                    }
                                 ],
                                 width : 150
                },
                {
                    headerText : "<spring:message code='sys.progmanagement.grid1.User_Define_7'/>",
                      children : [ {
                                      dataField : "funcUserDfn7",
                                      headerText : "<spring:message code='sys.progmanagement.grid1.Checked'/>",
                                      editable : true,
                                      renderer :
                                      {
                                          type : "CheckBoxEditRenderer",
                                          showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                                          editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                                          checkValue : "Y", // true, false 인 경우가 기본
                                          unCheckValue : "N",
                                          // 체크박스 Visible 함수
                                          visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField)
                                           {
                                             if(item.funcUserDfn7 == "Y")
                                             {
                                              return true; // checkbox visible
                                             }

                                             return true;
                                           }
                                      }  //renderer
                                    }
                                  , {
                                      dataField : "descUserDfn7",
                                      headerText : "<spring:message code='sys.progmanagement.grid1.Desc7'/>",
                                    }
                                 ],
                                 width : 150
                },
                {
                    headerText : "<spring:message code='sys.progmanagement.grid1.User_Define_8'/>",
                      children : [ {
                                      dataField : "funcUserDfn8",
                                      headerText : "<spring:message code='sys.progmanagement.grid1.Checked'/>",
                                      editable : true,
                                      renderer :
                                      {
                                          type : "CheckBoxEditRenderer",
                                          showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                                          editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                                          checkValue : "Y", // true, false 인 경우가 기본
                                          unCheckValue : "N",
                                          // 체크박스 Visible 함수
                                          visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField)
                                           {
                                             if(item.funcUserDfn8 == "Y")
                                             {
                                              return true; // checkbox visible
                                             }

                                             return true;
                                           }
                                      }  //renderer
                                    }
                                  , {
                                      dataField : "descUserDfn8",
                                      headerText : "<spring:message code='sys.progmanagement.grid1.Desc8'/>",
                                    }
                                 ],
                                 width : 150
                },
                {
                    headerText : "<spring:message code='sys.progmanagement.grid1.User_Define_9'/>",
                      children : [ {
                                      dataField : "funcUserDfn9",
                                      headerText : "<spring:message code='sys.progmanagement.grid1.Checked'/>",
                                      editable : true,
                                      renderer :
                                      {
                                          type : "CheckBoxEditRenderer",
                                          showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                                          editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                                          checkValue : "Y", // true, false 인 경우가 기본
                                          unCheckValue : "N",
                                          // 체크박스 Visible 함수
                                          visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField)
                                           {
                                             if(item.funcUserDfn9 == "Y")
                                             {
                                              return true; // checkbox visible
                                             }

                                             return true;
                                           }
                                      }  //renderer
                                    }
                                  , {
                                      dataField : "descUserDfn9",
                                      headerText : "<spring:message code='sys.progmanagement.grid1.Desc9'/>",
                                    }
                                 ],
                                 width : 150
                },
                {
                    headerText : "<spring:message code='sys.progmanagement.grid1.User_Define_10'/>",
                      children : [ {
                                      dataField : "funcUserDfn10",
                                      headerText : "<spring:message code='sys.progmanagement.grid1.Checked'/>",
                                      editable : true,
                                      renderer :
                                      {
                                          type : "CheckBoxEditRenderer",
                                          showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                                          editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                                          checkValue : "Y", // true, false 인 경우가 기본
                                          unCheckValue : "N",
                                          // 체크박스 Visible 함수
                                          visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField)
                                           {
                                             if(item.funcUserDfn10 == "Y")
                                             {
                                              return true; // checkbox visible
                                             }

                                             return true;
                                           }
                                      }  //renderer
                                    }
                                  , {
                                      dataField : "descUserDfn10",
                                      headerText : "<spring:message code='sys.progmanagement.grid1.Desc10'/>",
                                    }
                                 ],
                                 width : 150
                },
                {
                    headerText : "<spring:message code='sys.progmanagement.grid1.User_Define_11'/>",
                      children : [ {
                                      dataField : "funcUserDfn11",
                                      headerText : "<spring:message code='sys.progmanagement.grid1.Checked'/>",
                                      editable : true,
                                      renderer :
                                      {
                                          type : "CheckBoxEditRenderer",
                                          showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                                          editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                                          checkValue : "Y", // true, false 인 경우가 기본
                                          unCheckValue : "N",
                                          // 체크박스 Visible 함수
                                          visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField)
                                           {
                                             if(item.funcUserDfn11 == "Y")
                                             {
                                              return true; // checkbox visible
                                             }

                                             return true;
                                           }
                                      }  //renderer
                                    }
                                  , {
                                      dataField : "descUserDfn11",
                                      headerText : "<spring:message code='sys.progmanagement.grid1.Desc11'/>",
                                    }
                                 ],
                                 width : 150
                },
                {
                    headerText : "<spring:message code='sys.progmanagement.grid1.User_Define_12'/>",
                      children : [ {
                                      dataField : "funcUserDfn12",
                                      headerText : "<spring:message code='sys.progmanagement.grid1.Checked'/>",
                                      editable : true,
                                      renderer :
                                      {
                                          type : "CheckBoxEditRenderer",
                                          showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                                          editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                                          checkValue : "Y", // true, false 인 경우가 기본
                                          unCheckValue : "N",
                                          // 체크박스 Visible 함수
                                          visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField)
                                           {
                                             if(item.funcUserDfn12 == "Y")
                                             {
                                              return true; // checkbox visible
                                             }

                                             return true;
                                           }
                                      }  //renderer
                                    }
                                  , {
                                      dataField : "descUserDfn12",
                                      headerText : "<spring:message code='sys.progmanagement.grid1.Desc12'/>",
                                    }
                                 ],
                                 width : 150
                },
                {
                    headerText : "<spring:message code='sys.progmanagement.grid1.User_Define_13'/>",
                      children : [ {
                                      dataField : "funcUserDfn13",
                                      headerText : "<spring:message code='sys.progmanagement.grid1.Checked'/>",
                                      editable : true,
                                      renderer :
                                      {
                                          type : "CheckBoxEditRenderer",
                                          showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                                          editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                                          checkValue : "Y", // true, false 인 경우가 기본
                                          unCheckValue : "N",
                                          // 체크박스 Visible 함수
                                          visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField)
                                           {
                                             if(item.funcUserDfn13 == "Y")
                                             {
                                              return true; // checkbox visible
                                             }

                                             return true;
                                           }
                                      }  //renderer
                                    }
                                  , {
                                      dataField : "descUserDfn13",
                                      headerText : "<spring:message code='sys.progmanagement.grid1.Desc13'/>",
                                    }
                                 ],
                                 width : 150
                },
                {
                    headerText : "<spring:message code='sys.progmanagement.grid1.User_Define_14'/>",
                      children : [ {
                                      dataField : "funcUserDfn14",
                                      headerText : "<spring:message code='sys.progmanagement.grid1.Checked'/>",
                                      editable : true,
                                      renderer :
                                      {
                                          type : "CheckBoxEditRenderer",
                                          showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                                          editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                                          checkValue : "Y", // true, false 인 경우가 기본
                                          unCheckValue : "N",
                                          // 체크박스 Visible 함수
                                          visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField)
                                           {
                                             if(item.funcUserDfn14 == "Y")
                                             {
                                              return true; // checkbox visible
                                             }

                                             return true;
                                           }
                                      }  //renderer
                                    }
                                  , {
                                      dataField : "descUserDfn14",
                                      headerText : "<spring:message code='sys.progmanagement.grid1.Desc14'/>",
                                    }
                                 ],
                                 width : 150
                },
                {
                    headerText : "<spring:message code='sys.progmanagement.grid1.User_Define_15'/>",
                      children : [ {
                                      dataField : "funcUserDfn15",
                                      headerText : "<spring:message code='sys.progmanagement.grid1.Checked'/>",
                                      editable : true,
                                      renderer :
                                      {
                                          type : "CheckBoxEditRenderer",
                                          showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                                          editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                                          checkValue : "Y", // true, false 인 경우가 기본
                                          unCheckValue : "N",
                                          // 체크박스 Visible 함수
                                          visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField)
                                           {
                                             if(item.funcUserDfn15 == "Y")
                                             {
                                              return true; // checkbox visible
                                             }

                                             return true;
                                           }
                                      }  //renderer
                                    }
                                  , {
                                      dataField : "descUserDfn15",
                                      headerText : "<spring:message code='sys.progmanagement.grid1.Desc15'/>",
                                    }
                                 ],
                                 width : 150
                },
                {
                    headerText : "<spring:message code='sys.progmanagement.grid1.User_Define_16'/>",
                      children : [ {
                                      dataField : "funcUserDfn16",
                                      headerText : "<spring:message code='sys.progmanagement.grid1.Checked'/>",
                                      editable : true,
                                      renderer :
                                      {
                                          type : "CheckBoxEditRenderer",
                                          showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                                          editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                                          checkValue : "Y", // true, false 인 경우가 기본
                                          unCheckValue : "N",
                                          // 체크박스 Visible 함수
                                          visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField)
                                           {
                                             if(item.funcUserDfn16 == "Y")
                                             {
                                              return true; // checkbox visible
                                             }

                                             return true;
                                           }
                                      }  //renderer
                                    }
                                  , {
                                      dataField : "descUserDfn16",
                                      headerText : "<spring:message code='sys.progmanagement.grid1.Desc16'/>",
                                    }
                                 ],
                                 width : 150
                },
                {
                    headerText : "<spring:message code='sys.progmanagement.grid1.User_Define_17'/>",
                      children : [ {
                                      dataField : "funcUserDfn17",
                                      headerText : "<spring:message code='sys.progmanagement.grid1.Checked'/>",
                                      editable : true,
                                      renderer :
                                      {
                                          type : "CheckBoxEditRenderer",
                                          showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                                          editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                                          checkValue : "Y", // true, false 인 경우가 기본
                                          unCheckValue : "N",
                                          // 체크박스 Visible 함수
                                          visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField)
                                           {
                                             if(item.funcUserDfn17 == "Y")
                                             {
                                              return true; // checkbox visible
                                             }

                                             return true;
                                           }
                                      }  //renderer
                                    }
                                  , {
                                      dataField : "descUserDfn17",
                                      headerText : "<spring:message code='sys.progmanagement.grid1.Desc17'/>",
                                    }
                                 ],
                                 width : 150
                },
                {
                    headerText : "<spring:message code='sys.progmanagement.grid1.User_Define_18'/>",
                      children : [ {
                                      dataField : "funcUserDfn18",
                                      headerText : "<spring:message code='sys.progmanagement.grid1.Checked'/>",
                                      editable : true,
                                      renderer :
                                      {
                                          type : "CheckBoxEditRenderer",
                                          showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                                          editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                                          checkValue : "Y", // true, false 인 경우가 기본
                                          unCheckValue : "N",
                                          // 체크박스 Visible 함수
                                          visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField)
                                           {
                                             if(item.funcUserDfn18 == "Y")
                                             {
                                              return true; // checkbox visible
                                             }

                                             return true;
                                           }
                                      }  //renderer
                                    }
                                  , {
                                      dataField : "descUserDfn18",
                                      headerText : "<spring:message code='sys.progmanagement.grid1.Desc18'/>",
                                    }
                                 ],
                                 width : 150
                },
                {
                    headerText : "<spring:message code='sys.progmanagement.grid1.User_Define_19'/>",
                      children : [ {
                                      dataField : "funcUserDfn19",
                                      headerText : "<spring:message code='sys.progmanagement.grid1.Checked'/>",
                                      editable : true,
                                      renderer :
                                      {
                                          type : "CheckBoxEditRenderer",
                                          showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                                          editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                                          checkValue : "Y", // true, false 인 경우가 기본
                                          unCheckValue : "N",
                                          // 체크박스 Visible 함수
                                          visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField)
                                           {
                                             if(item.funcUserDfn19 == "Y")
                                             {
                                              return true; // checkbox visible
                                             }

                                             return true;
                                           }
                                      }  //renderer
                                    }
                                  , {
                                      dataField : "descUserDfn19",
                                      headerText : "<spring:message code='sys.progmanagement.grid1.Desc19'/>",
                                    }
                                 ],
                                 width : 150
                },
                {
                    headerText : "<spring:message code='sys.progmanagement.grid1.User_Define_20'/>",
                      children : [ {
                                      dataField : "funcUserDfn20",
                                      headerText : "<spring:message code='sys.progmanagement.grid1.Checked'/>",
                                      editable : true,
                                      renderer :
                                      {
                                          type : "CheckBoxEditRenderer",
                                          showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                                          editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                                          checkValue : "Y", // true, false 인 경우가 기본
                                          unCheckValue : "N",
                                          // 체크박스 Visible 함수
                                          visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField)
                                           {
                                             if(item.funcUserDfn20 == "Y")
                                             {
                                              return true; // checkbox visible
                                             }

                                             return true;
                                           }
                                      }  //renderer
                                    }
                                  , {
                                      dataField : "descUserDfn20",
                                      headerText : "<spring:message code='sys.progmanagement.grid1.Desc20'/>",
                                    }
                                 ],
                                 width : 150
                },
                {
                    headerText : "<spring:message code='sys.progmanagement.grid1.User_Define_21'/>",
                      children : [ {
                                      dataField : "funcUserDfn21",
                                      headerText : "<spring:message code='sys.progmanagement.grid1.Checked'/>",
                                      editable : true,
                                      renderer :
                                      {
                                          type : "CheckBoxEditRenderer",
                                          showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                                          editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                                          checkValue : "Y", // true, false 인 경우가 기본
                                          unCheckValue : "N",
                                          // 체크박스 Visible 함수
                                          visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField)
                                           {
                                             if(item.funcUserDfn21 == "Y")
                                             {
                                              return true; // checkbox visible
                                             }

                                             return true;
                                           }
                                      }  //renderer
                                    }
                                  , {
                                      dataField : "descUserDfn21",
                                      headerText : "<spring:message code='sys.progmanagement.grid1.Desc21'/>",
                                    }
                                 ],
                                 width : 150
                },
                {
                    headerText : "<spring:message code='sys.progmanagement.grid1.User_Define_22'/>",
                      children : [ {
                                      dataField : "funcUserDfn22",
                                      headerText : "<spring:message code='sys.progmanagement.grid1.Checked'/>",
                                      editable : true,
                                      renderer :
                                      {
                                          type : "CheckBoxEditRenderer",
                                          showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                                          editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                                          checkValue : "Y", // true, false 인 경우가 기본
                                          unCheckValue : "N",
                                          // 체크박스 Visible 함수
                                          visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField)
                                           {
                                             if(item.funcUserDfn22 == "Y")
                                             {
                                              return true; // checkbox visible
                                             }

                                             return true;
                                           }
                                      }  //renderer
                                    }
                                  , {
                                      dataField : "descUserDfn22",
                                      headerText : "<spring:message code='sys.progmanagement.grid1.Desc22'/>",
                                    }
                                 ],
                                 width : 150
                },
                {
                    headerText : "<spring:message code='sys.progmanagement.grid1.User_Define_23'/>",
                      children : [ {
                                      dataField : "funcUserDfn23",
                                      headerText : "<spring:message code='sys.progmanagement.grid1.Checked'/>",
                                      editable : true,
                                      renderer :
                                      {
                                          type : "CheckBoxEditRenderer",
                                          showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                                          editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                                          checkValue : "Y", // true, false 인 경우가 기본
                                          unCheckValue : "N",
                                          // 체크박스 Visible 함수
                                          visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField)
                                           {
                                             if(item.funcUserDfn23 == "Y")
                                             {
                                              return true; // checkbox visible
                                             }

                                             return true;
                                           }
                                      }  //renderer
                                    }
                                  , {
                                      dataField : "descUserDfn23",
                                      headerText : "<spring:message code='sys.progmanagement.grid1.Desc23'/>",
                                    }
                                 ],
                                 width : 150
                },
                {
                    headerText : "<spring:message code='sys.progmanagement.grid1.User_Define_24'/>",
                      children : [ {
                                      dataField : "funcUserDfn24",
                                      headerText : "<spring:message code='sys.progmanagement.grid1.Checked'/>",
                                      editable : true,
                                      renderer :
                                      {
                                          type : "CheckBoxEditRenderer",
                                          showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                                          editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                                          checkValue : "Y", // true, false 인 경우가 기본
                                          unCheckValue : "N",
                                          // 체크박스 Visible 함수
                                          visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField)
                                           {
                                             if(item.funcUserDfn24 == "Y")
                                             {
                                              return true; // checkbox visible
                                             }

                                             return true;
                                           }
                                      }  //renderer
                                    }
                                  , {
                                      dataField : "descUserDfn24",
                                      headerText : "<spring:message code='sys.progmanagement.grid1.Desc24'/>",
                                    }
                                 ],
                                 width : 150
                },
                {
                    headerText : "<spring:message code='sys.progmanagement.grid1.User_Define_25'/>",
                      children : [ {
                                      dataField : "funcUserDfn25",
                                      headerText : "<spring:message code='sys.progmanagement.grid1.Checked'/>",
                                      editable : true,
                                      renderer :
                                      {
                                          type : "CheckBoxEditRenderer",
                                          showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                                          editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                                          checkValue : "Y", // true, false 인 경우가 기본
                                          unCheckValue : "N",
                                          // 체크박스 Visible 함수
                                          visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField)
                                           {
                                             if(item.funcUserDfn25 == "Y")
                                             {
                                              return true; // checkbox visible
                                             }

                                             return true;
                                           }
                                      }  //renderer
                                    }
                                  , {
                                      dataField : "descUserDfn25",
                                      headerText : "<spring:message code='sys.progmanagement.grid1.Desc25'/>",
                                    }
                                 ],
                                 width : 150
                },
                {
                    headerText : "<spring:message code='sys.progmanagement.grid1.User_Define_26'/>",
                      children : [ {
                                      dataField : "funcUserDfn26",
                                      headerText : "<spring:message code='sys.progmanagement.grid1.Checked'/>",
                                      editable : true,
                                      renderer :
                                      {
                                          type : "CheckBoxEditRenderer",
                                          showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                                          editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                                          checkValue : "Y", // true, false 인 경우가 기본
                                          unCheckValue : "N",
                                          // 체크박스 Visible 함수
                                          visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField)
                                           {
                                             if(item.funcUserDfn26 == "Y")
                                             {
                                              return true; // checkbox visible
                                             }

                                             return true;
                                           }
                                      }  //renderer
                                    }
                                  , {
                                      dataField : "descUserDfn26",
                                      headerText : "<spring:message code='sys.progmanagement.grid1.Desc26'/>",
                                    }
                                 ],
                                 width : 150
                },
                {
                    headerText : "<spring:message code='sys.progmanagement.grid1.User_Define_27'/>",
                      children : [ {
                                      dataField : "funcUserDfn27",
                                      headerText : "<spring:message code='sys.progmanagement.grid1.Checked'/>",
                                      editable : true,
                                      renderer :
                                      {
                                          type : "CheckBoxEditRenderer",
                                          showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                                          editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                                          checkValue : "Y", // true, false 인 경우가 기본
                                          unCheckValue : "N",
                                          // 체크박스 Visible 함수
                                          visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField)
                                           {
                                             if(item.funcUserDfn27 == "Y")
                                             {
                                              return true; // checkbox visible
                                             }

                                             return true;
                                           }
                                      }  //renderer
                                    }
                                  , {
                                      dataField : "descUserDfn27",
                                      headerText : "<spring:message code='sys.progmanagement.grid1.Desc27'/>",
                                    }
                                 ],
                                 width : 150
                },
                {
                    headerText : "<spring:message code='sys.progmanagement.grid1.User_Define_28'/>",
                      children : [ {
                                      dataField : "funcUserDfn28",
                                      headerText : "<spring:message code='sys.progmanagement.grid1.Checked'/>",
                                      editable : true,
                                      renderer :
                                      {
                                          type : "CheckBoxEditRenderer",
                                          showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                                          editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                                          checkValue : "Y", // true, false 인 경우가 기본
                                          unCheckValue : "N",
                                          // 체크박스 Visible 함수
                                          visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField)
                                           {
                                             if(item.funcUserDfn28 == "Y")
                                             {
                                              return true; // checkbox visible
                                             }

                                             return true;
                                           }
                                      }  //renderer
                                    }
                                  , {
                                      dataField : "descUserDfn28",
                                      headerText : "<spring:message code='sys.progmanagement.grid1.Desc28'/>",
                                    }
                                 ],
                                 width : 150
                },
                {
                    headerText : "<spring:message code='sys.progmanagement.grid1.User_Define_29'/>",
                      children : [ {
                                      dataField : "funcUserDfn29",
                                      headerText : "<spring:message code='sys.progmanagement.grid1.Checked'/>",
                                      editable : true,
                                      renderer :
                                      {
                                          type : "CheckBoxEditRenderer",
                                          showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                                          editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                                          checkValue : "Y", // true, false 인 경우가 기본
                                          unCheckValue : "N",
                                          // 체크박스 Visible 함수
                                          visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField)
                                           {
                                             if(item.funcUserDfn29 == "Y")
                                             {
                                              return true; // checkbox visible
                                             }

                                             return true;
                                           }
                                      }  //renderer
                                    }
                                  , {
                                      dataField : "descUserDfn29",
                                      headerText : "<spring:message code='sys.progmanagement.grid1.Desc29'/>",
                                    }
                                 ],
                                 width : 150
                },
                {
                    headerText : "<spring:message code='sys.progmanagement.grid1.User_Define_30'/>",
                      children : [ {
                                      dataField : "funcUserDfn30",
                                      headerText : "<spring:message code='sys.progmanagement.grid1.Checked'/>",
                                      editable : true,
                                      renderer :
                                      {
                                          type : "CheckBoxEditRenderer",
                                          showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                                          editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                                          checkValue : "Y", // true, false 인 경우가 기본
                                          unCheckValue : "N",
                                          // 체크박스 Visible 함수
                                          visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField)
                                           {
                                             if(item.funcUserDfn30 == "Y")
                                             {
                                              return true; // checkbox visible
                                             }

                                             return true;
                                           }
                                      }  //renderer
                                    }
                                  , {
                                      dataField : "descUserDfn30",
                                      headerText : "<spring:message code='sys.progmanagement.grid1.Desc30'/>",
                                    }
                                 ],
                                 width : 150
                },
                {
                    dataField : "pgmCode",
                    headerText : "<spring:message code='sys.progmanagement.grid1.Id'/>",
                    editable : false,
                    visible : false,
                    width : 150
                }
    ];


//AUIGrid 메소드

function auiCellEditignHandler(event)
{
  if(event.type == "cellEditBegin")
  {
      console.log("에디팅 시작(cellEditBegin) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);
  }
  else if(event.type == "cellEditEnd")
  {
      console.log("에디팅 종료(cellEditEnd) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);

      if (event.dataField == "pgmName" && event.headerText == "NAME" )
      {
          AUIGrid.setCellValue(myGridID, event.rowIndex, 4, event.value);
      }
      else if (event.dataField == "fromDtTypeId")
      {
          if(event.value == "") {
              AUIGrid.setCellValue(myGridID, event.rowIndex, 6, "");   // fromDtFieldNm
              AUIGrid.setCellValue(myGridID, event.rowIndex, 7, "");   // fromDtVal
          }
      }
      else if (event.dataField == "toDtTypeId")
      {
          if(event.value == "") {
              AUIGrid.setCellValue(myGridID, event.rowIndex, 9, "");    // toDtFieldNm
              AUIGrid.setCellValue(myGridID, event.rowIndex, 10, "");   // toDtVal
          }
      }
  }
  else if(event.type == "cellEditCancel")
  {
      console.log("에디팅 취소(cellEditCancel) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);
  }

}

//행 추가 이벤트 핸들러
function auiAddRowHandler(event)
{
  gAddRowCnt = gAddRowCnt + event.items.length ;
    console.log(event.type + " 이벤트\r\n" + "삽입된 행 인덱스 : " + event.rowIndex + "\r\n삽입된 행 개수 : " + event.items.length );
}

//Main 행 추가, 삽입
function fnAddRowPgmId()
{
  checkboxPgmIdChangeHandler("hide");

  var item = new Object();
  item.orgCode ="";
  item.pgmName ="";
  item.pgmPath ="";
  item.pgmDesc ="";
  // parameter
  // item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
  // rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래

  AUIGrid.addRow(myGridID, item, "first");
}

//Sub
function fnAddRowTrans()
{
  if ($("#paramPgmId").val().length == 0)
    {
       Common.alert("<spring:message code='sys.msg.necessary' arguments='programID' htmlEscape='false'/>");
       return false;
    }

  gAddRowCnt = gAddRowCnt +1;

  if ( gAddRowCnt > 1)
  {
      Common.alert("<spring:message code='sys.msg.limitMore' arguments='Data Add ; 1' htmlEscape='false' argumentSeparator=';' />");
    return false;
  }

    var item = new Object();
    item.funcView  = "N";
    item.funcChng  = "N";
    item.funcPrt   = "N";

    item.funcUserDfn1 ="N";
    item.descUserDfn1 ="";
    item.funcUserDfn2 ="N";
    item.descUserDfn2 ="";
    item.funcUserDfn3 ="N";
    item.descUserDfn3 ="";
    item.funcUserDfn4 ="N";
    item.descUserDfn4 ="";
    item.funcUserDfn5 ="N";
    item.descUserDfn5 ="";

    item.funcUserDfn6 ="N";
    item.descUserDfn6 ="";
    item.funcUserDfn7 ="N";
    item.descUserDfn7 ="";
    item.funcUserDfn8 ="N";
    item.descUserDfn8 ="";
    item.funcUserDfn9 ="N";
    item.descUserDfn9 ="";
    item.funcUserDfn10 ="N";
    item.descUserDfn10 ="";

    item.funcUserDfn11 ="N";
    item.descUserDfn11 ="";
    item.funcUserDfn12 ="N";
    item.descUserDfn12 ="";
    item.funcUserDfn13 ="N";
    item.descUserDfn13 ="";
    item.funcUserDfn14 ="N";
    item.descUserDfn14 ="";
    item.funcUserDfn15 ="N";
    item.descUserDfn15 ="";

    item.funcUserDfn16 ="N";
    item.descUserDfn16 ="";
    item.funcUserDfn17 ="N";
    item.descUserDfn17 ="";
    item.funcUserDfn18 ="N";
    item.descUserDfn18 ="";
    item.funcUserDfn19 ="N";
    item.descUserDfn19 ="";
    item.funcUserDfn20 ="N";
    item.descUserDfn20 ="";

    item.funcUserDfn21 ="N";
    item.descUserDfn21 ="";
    item.funcUserDfn22 ="N";
    item.descUserDfn22 ="";
    item.funcUserDfn23 ="N";
    item.descUserDfn23 ="";
    item.funcUserDfn24 ="N";
    item.descUserDfn24 ="";
    item.funcUserDfn25 ="N";
    item.descUserDfn25 ="";

    item.funcUserDfn26 ="N";
    item.descUserDfn26 ="";
    item.funcUserDfn27 ="N";
    item.descUserDfn27 ="";
    item.funcUserDfn28 ="N";
    item.descUserDfn28 ="";
    item.funcUserDfn29 ="N";
    item.descUserDfn29 ="";
    item.funcUserDfn30 ="N";
    item.descUserDfn30 ="";
  // parameter
  // item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
  // rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
  AUIGrid.addRow(transGridID, item, "first");
}

//행 삭제 이벤트 핸들러
function auiRemoveRowHandler(event)
{
  console.log (event.type + " 이벤트 :  " + ", 삭제된 행 개수 : " + event.items.length + ", softRemoveRowMode : " + event.softRemoveRowMode);
}

//행 삭제 이벤트 핸들러
function auiRemoveRowHandlerDetail(event)
{
  console.log (event.type + " 이벤트상세 :  " + ", 삭제된 행 개수 : " + event.items.length + ", softRemoveRowMode : " + event.softRemoveRowMode);
}

//행 삭제 메소드
function removeRow()
{
    console.log("removeRow method")
  AUIGrid.removeRow(myGridID,"selectedIndex");
}

//Make Use_yn ComboList, tooltip
function getOrgDropList()
{
    var list =  ["ORG", "LOG","SAL", "PAY", "SVC", "CCR", "CMM", "SYS", "MIS","SCM","FCM","HCT","RND"];
    return list;
}

function fnSetPgmIdParamSet(myGridID, rowIndex)
{
    $("#paramPgmId").val(AUIGrid.getCellValue(myGridID, rowIndex, "pgmCode"));
    $("#pgmId").val(AUIGrid.getCellValue(myGridID, rowIndex, "pgmCode"));

    console.log("paramPgmId: "+ $("#paramPgmId").val() + "pgmId: "+ $("#pgmId").val() );
}


function getItemsByCheckedField(selectedGrid)
{
  // 체크된 item 반환
  var activeItems = AUIGrid.getItemsByValue(selectedGrid, "checkFlag", true);
  var checkedRowItem = [];
  var str = "";

  for(var i=0, len = activeItems.length; i<len; i++)
  {
      checkedRowItem = activeItems[i];
      str += "chkRowIdx : " + checkedRowItem.rowIndex + ", chkId :" + checkedRowItem.stusCodeId + ", chkName : " + checkedRowItem.codeName  + "\n";
  }
}

function fn_commCodeSearch(){
    Common.ajax("GET", "/common/selectCodeList.do",  {groupCode : '423'}, function(result) {
        var temp    = { codeId : "", codeName : "" };
        keyValueList.push(temp);
        for ( var i = 0 ; i < result.length ; i++ ) {
            keyValueList.push(result[i]);
        }
    }, null, {async : false});
}

function fnSelectPgmListAjax()
{
     fnTransGridReset();
     Common.ajax("GET", "/program/selectProgramList.do"
               , $("#MainForm").serialize()
               , function(result)
               {
                  console.log("성공 data : " + result);
                  checkboxPgmIdChangeHandler("show");
                  AUIGrid.setGridData(myGridID, result);
                  if(result != null && result.length > 0)
                  {
                    fnSetPgmIdParamSet(myGridID, 0);
                  }
                  oldRowIndex = -1; // 20190911 KR-OHK Initialize Variables
               });
}

function fnValidationCheck()
{
    var result = true;
    var addList = AUIGrid.getAddedRowItems(myGridID);
    var udtList = AUIGrid.getEditedRowItems(myGridID);
    var delList = AUIGrid.getRemovedItems(myGridID);

    if (addList.length == 0  && udtList.length == 0 && delList.length == 0)
    {
      Common.alert("No Change");
      return false;
    }

    for (var i = 0; i < addList.length; i++)
    {
      var orgCode  = addList[i].orgCode;
      var pgmName  = addList[i].pgmName;
      var pgmPath  = addList[i].pgmPath;

        if (orgCode == "" || orgCode.length == 0)
        {
          result = false;
          // {0} is required.
          Common.alert("<spring:message code='sys.msg.necessary' arguments='ORG CODE' htmlEscape='false'/>");
          break;
        }

        if (pgmName == "" || pgmName.length == 0)
        {
          result = false;
          // {0} is required.
          Common.alert("<spring:message code='sys.msg.necessary' arguments='PGM NAME' htmlEscape='false'/>");
          break;
        }

        if (pgmPath == "" || pgmPath.length == 0)
        {
          result = false;
          // {0} is required.
          Common.alert("<spring:message code='sys.msg.necessary' arguments='PGM PATH' htmlEscape='false'/>");
          break;
        }
    }

    for (var i = 0; i < udtList.length; i++)
    {
      var pgmCode  = udtList[i].pgmCode;

        if (pgmCode == "" || pgmCode.length == 0)
        {
          result = false;
          // {0} is required.
          Common.alert("<spring:message code='sys.msg.necessary' arguments='PGM CODE' htmlEscape='false'/>");
          break;
        }
    }

    for (var i = 0; i < delList.length; i++)
    {
        var pgmCode  = delList[i].pgmCode;

        if (pgmCode == "" || pgmCode.length == 0)
        {
          result = false;
          // {0} is required.
          Common.alert("<spring:message code='sys.msg.necessary' arguments='PGM CODE' htmlEscape='false'/>");
          break;
        }
    }

    return result;
}

function fnSelectPgmTransListAjax()
{
     fnTransGridReset();
     Common.ajax("GET", "/program/selectPgmTranList.do"
               , $("#MainForm").serialize()
               , function(result)
               {
                  console.log("성공 data : " + result);
                  //checkboxPgmIdChangeHandler("show");
                  AUIGrid.setGridData(transGridID, result);
                  if(result != null && result.length > 0)
                  {
                    fnSetPgmIdParamSet(transGridID, 0);
                    gAddRowCnt++;
                  }
               });
}



function fnSavePgmId()
{
  if (fnValidationCheck() == false)
  {
    return false;
  }

    fnTransGridReset();
  Common.ajax("POST", "/program/saveProgramId.do"
        , GridCommon.getEditData(myGridID)
        , function(result)
         {
            Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
            fnSelectPgmListAjax() ;

            console.log("성공." + JSON.stringify(result));
            console.log("data : " + result.data);
         }
         , function(jqXHR, textStatus, errorThrown)
        {
          try
          {
            console.log("Fail Status : " + jqXHR.status);
            console.log("code : "        + jqXHR.responseJSON.code);
            console.log("message : "     + jqXHR.responseJSON.message);
            console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
          }
          catch (e)
          {
            console.log(e);
          }
          alert("Fail : " + jqXHR.responseJSON.message);
        });
}

function fnUpdateTrans()
{

    var dfnDesc1 = AUIGrid.getCellValue(transGridID, 0, "descUserDfn1");
    var dfnDesc2 = AUIGrid.getCellValue(transGridID, 0, "descUserDfn2");
    var dfnDesc3 = AUIGrid.getCellValue(transGridID, 0, "descUserDfn3");
    var dfnDesc4 = AUIGrid.getCellValue(transGridID, 0, "descUserDfn4");
    var dfnDesc5 = AUIGrid.getCellValue(transGridID, 0, "descUserDfn5");
    var dfnDesc6 = AUIGrid.getCellValue(transGridID, 0, "descUserDfn6");
    var dfnDesc7 = AUIGrid.getCellValue(transGridID, 0, "descUserDfn7");
    var dfnDesc8 = AUIGrid.getCellValue(transGridID, 0, "descUserDfn8");
    var dfnDesc9 = AUIGrid.getCellValue(transGridID, 0, "descUserDfn9");
    var dfnDesc10 = AUIGrid.getCellValue(transGridID, 0, "descUserDfn10");
    var dfnDesc11 = AUIGrid.getCellValue(transGridID, 0, "descUserDfn11");
    var dfnDesc12 = AUIGrid.getCellValue(transGridID, 0, "descUserDfn12");
    var dfnDesc13 = AUIGrid.getCellValue(transGridID, 0, "descUserDfn13");
    var dfnDesc14 = AUIGrid.getCellValue(transGridID, 0, "descUserDfn14");
    var dfnDesc15 = AUIGrid.getCellValue(transGridID, 0, "descUserDfn15");
    var dfnDesc16 = AUIGrid.getCellValue(transGridID, 0, "descUserDfn16");
    var dfnDesc17 = AUIGrid.getCellValue(transGridID, 0, "descUserDfn17");
    var dfnDesc18 = AUIGrid.getCellValue(transGridID, 0, "descUserDfn18");
    var dfnDesc19 = AUIGrid.getCellValue(transGridID, 0, "descUserDfn19");
    var dfnDesc20 = AUIGrid.getCellValue(transGridID, 0, "descUserDfn20");
    var dfnDesc21 = AUIGrid.getCellValue(transGridID, 0, "descUserDfn21");
    var dfnDesc22 = AUIGrid.getCellValue(transGridID, 0, "descUserDfn22");
    var dfnDesc23 = AUIGrid.getCellValue(transGridID, 0, "descUserDfn23");
    var dfnDesc24 = AUIGrid.getCellValue(transGridID, 0, "descUserDfn24");
    var dfnDesc25 = AUIGrid.getCellValue(transGridID, 0, "descUserDfn25");

    var dfnChk1 = AUIGrid.getCellValue(transGridID, 0, "funcUserDfn1");
    var dfnChk2 = AUIGrid.getCellValue(transGridID, 0, "funcUserDfn2");
    var dfnChk3 = AUIGrid.getCellValue(transGridID, 0, "funcUserDfn3");
    var dfnChk4 = AUIGrid.getCellValue(transGridID, 0, "funcUserDfn4");
    var dfnChk5 = AUIGrid.getCellValue(transGridID, 0, "funcUserDfn5");
    var dfnChk6 = AUIGrid.getCellValue(transGridID, 0, "funcUserDfn6");
    var dfnChk7 = AUIGrid.getCellValue(transGridID, 0, "funcUserDfn7");
    var dfnChk8 = AUIGrid.getCellValue(transGridID, 0, "funcUserDfn8");
    var dfnChk9 = AUIGrid.getCellValue(transGridID, 0, "funcUserDfn9");
    var dfnChk10 = AUIGrid.getCellValue(transGridID, 0, "funcUserDfn10");
    var dfnChk11 = AUIGrid.getCellValue(transGridID, 0, "funcUserDfn11");
    var dfnChk12 = AUIGrid.getCellValue(transGridID, 0, "funcUserDfn12");
    var dfnChk13 = AUIGrid.getCellValue(transGridID, 0, "funcUserDfn13");
    var dfnChk14 = AUIGrid.getCellValue(transGridID, 0, "funcUserDfn14");
    var dfnChk15 = AUIGrid.getCellValue(transGridID, 0, "funcUserDfn15");
    var dfnChk16 = AUIGrid.getCellValue(transGridID, 0, "funcUserDfn16");
    var dfnChk17 = AUIGrid.getCellValue(transGridID, 0, "funcUserDfn17");
    var dfnChk18 = AUIGrid.getCellValue(transGridID, 0, "funcUserDfn18");
    var dfnChk19 = AUIGrid.getCellValue(transGridID, 0, "funcUserDfn19");
    var dfnChk20 = AUIGrid.getCellValue(transGridID, 0, "funcUserDfn20");
    var dfnChk21 = AUIGrid.getCellValue(transGridID, 0, "funcUserDfn21");
    var dfnChk22 = AUIGrid.getCellValue(transGridID, 0, "funcUserDfn22");
    var dfnChk23 = AUIGrid.getCellValue(transGridID, 0, "funcUserDfn23");
    var dfnChk24 = AUIGrid.getCellValue(transGridID, 0, "funcUserDfn24");
    var dfnChk25 = AUIGrid.getCellValue(transGridID, 0, "funcUserDfn25");

    if(dfnChk1 == "Y" && (dfnDesc1 == "" || typeof(dfnDesc1) == "undefined")){
        //The {0} Must Exist.
        Common.alert("<spring:message code='sys.msg.Exists' arguments='UserDFN#1 Desc' htmlEscape='false'/>");
        return false;
    }

    if(dfnChk2 == "Y" && (dfnDesc2 == ""  || typeof(dfnDesc2) == "undefined")){
        //The {0} Must Exist.
        Common.alert("<spring:message code='sys.msg.Exists' arguments='UserDFN#2 Desc' htmlEscape='false'/>");
        return false;
    }

    if(dfnChk3 == "Y" && (dfnDesc3 == "" || typeof(dfnDesc3) == "undefined")){
        //The {0} Must Exist.
        Common.alert("<spring:message code='sys.msg.Exists' arguments='UserDFN#3 Desc' htmlEscape='false'/>");
        return false;
    }

    if(dfnChk4 == "Y" && (dfnDesc4 == "" || typeof(dfnDesc4) == "undefined")){
        //The {0} Must Exist.
        Common.alert("<spring:message code='sys.msg.Exists' arguments='UserDFN#4 Desc' htmlEscape='false'/>");
        return false;
    }

    if(dfnChk5 == "Y" && (dfnDesc5 == "" || typeof(dfnDesc5) == "undefined")){
        //The {0} Must Exist.
        Common.alert("<spring:message code='sys.msg.Exists' arguments='UserDFN#5 Desc' htmlEscape='false'/>");
        return false;
    }

    ///////////

    if(dfnChk6 == "Y" && (dfnDesc6 == "" || typeof(dfnDesc6) == "undefined")){
        //The {0} Must Exist.
        Common.alert("<spring:message code='sys.msg.Exists' arguments='UserDFN#6 Desc' htmlEscape='false'/>");
        return false;
    }

    if(dfnChk7 == "Y" && (dfnDesc7 == ""  || typeof(dfnDesc7) == "undefined")){
        //The {0} Must Exist.
        Common.alert("<spring:message code='sys.msg.Exists' arguments='UserDFN#7 Desc' htmlEscape='false'/>");
        return false;
    }

    if(dfnChk8 == "Y" && (dfnDesc8 == "" || typeof(dfnDesc8) == "undefined")){
        //The {0} Must Exist.
        Common.alert("<spring:message code='sys.msg.Exists' arguments='UserDFN#8 Desc' htmlEscape='false'/>");
        return false;
    }

    if(dfnChk9 == "Y" && (dfnDesc9 == "" || typeof(dfnDesc9) == "undefined")){
        //The {0} Must Exist.
        Common.alert("<spring:message code='sys.msg.Exists' arguments='UserDFN#9 Desc' htmlEscape='false'/>");
        return false;
    }

    if(dfnChk10 == "Y" && (dfnDesc10 == "" || typeof(dfnDesc10) == "undefined")){
        //The {0} Must Exist.
        Common.alert("<spring:message code='sys.msg.Exists' arguments='UserDFN#10 Desc' htmlEscape='false'/>");
        return false;
    }

    /////////////////////////////

    if(dfnChk11 == "Y" && (dfnDesc11 == "" || typeof(dfnDesc11) == "undefined")){
        //The {0} Must Exist.
        Common.alert("<spring:message code='sys.msg.Exists' arguments='UserDFN#11 Desc' htmlEscape='false'/>");
        return false;
    }

    if(dfnChk12 == "Y" && (dfnDesc12 == ""  || typeof(dfnDesc12) == "undefined")){
        //The {0} Must Exist.
        Common.alert("<spring:message code='sys.msg.Exists' arguments='UserDFN#12 Desc' htmlEscape='false'/>");
        return false;
    }

    if(dfnChk13 == "Y" && (dfnDesc13 == "" || typeof(dfnDesc13) == "undefined")){
        //The {0} Must Exist.
        Common.alert("<spring:message code='sys.msg.Exists' arguments='UserDFN#13 Desc' htmlEscape='false'/>");
        return false;
    }

    if(dfnChk14 == "Y" && (dfnDesc14 == "" || typeof(dfnDesc14) == "undefined")){
        //The {0} Must Exist.
        Common.alert("<spring:message code='sys.msg.Exists' arguments='UserDFN#14 Desc' htmlEscape='false'/>");
        return false;
    }

    if(dfnChk15 == "Y" && (dfnDesc15 == "" || typeof(dfnDesc15) == "undefined")){
        //The {0} Must Exist.
        Common.alert("<spring:message code='sys.msg.Exists' arguments='UserDFN#15 Desc' htmlEscape='false'/>");
        return false;
    }

    /////////////////////////////////////////////////////


    if(dfnChk16 == "Y" && (dfnDesc16 == "" || typeof(dfnDesc16) == "undefined")){
        //The {0} Must Exist.
        Common.alert("<spring:message code='sys.msg.Exists' arguments='UserDFN#16 Desc' htmlEscape='false'/>");
        return false;
    }

    if(dfnChk17 == "Y" && (dfnDesc17 == ""  || typeof(dfnDesc17) == "undefined")){
        //The {0} Must Exist.
        Common.alert("<spring:message code='sys.msg.Exists' arguments='UserDFN#17 Desc' htmlEscape='false'/>");
        return false;
    }

    if(dfnChk18 == "Y" && (dfnDesc18 == "" || typeof(dfnDesc18) == "undefined")){
        //The {0} Must Exist.
        Common.alert("<spring:message code='sys.msg.Exists' arguments='UserDFN#18 Desc' htmlEscape='false'/>");
        return false;
    }

    if(dfnChk19 == "Y" && (dfnDesc19 == "" || typeof(dfnDesc19) == "undefined")){
        //The {0} Must Exist.
        Common.alert("<spring:message code='sys.msg.Exists' arguments='UserDFN#19 Desc' htmlEscape='false'/>");
        return false;
    }

    if(dfnChk20 == "Y" && (dfnDesc20 == "" || typeof(dfnDesc20) == "undefined")){
        //The {0} Must Exist.
        Common.alert("<spring:message code='sys.msg.Exists' arguments='UserDFN#20 Desc' htmlEscape='false'/>");
        return false;
    }

    /////////////////////////////

    if(dfnChk21 == "Y" && (dfnDesc21 == "" || typeof(dfnDesc21) == "undefined")){
        //The {0} Must Exist.
        Common.alert("<spring:message code='sys.msg.Exists' arguments='UserDFN#21 Desc' htmlEscape='false'/>");
        return false;
    }

    if(dfnChk22 == "Y" && (dfnDesc22 == ""  || typeof(dfnDesc22) == "undefined")){
        //The {0} Must Exist.
        Common.alert("<spring:message code='sys.msg.Exists' arguments='UserDFN#22 Desc' htmlEscape='false'/>");
        return false;
    }

    if(dfnChk23 == "Y" && (dfnDesc23 == "" || typeof(dfnDesc23) == "undefined")){
        //The {0} Must Exist.
        Common.alert("<spring:message code='sys.msg.Exists' arguments='UserDFN#23 Desc' htmlEscape='false'/>");
        return false;
    }

    if(dfnChk24 == "Y" && (dfnDesc24 == "" || typeof(dfnDesc24) == "undefined")){
        //The {0} Must Exist.
        Common.alert("<spring:message code='sys.msg.Exists' arguments='UserDFN#24 Desc' htmlEscape='false'/>");
        return false;
    }

    if(dfnChk25 == "Y" && (dfnDesc25 == "" || typeof(dfnDesc25) == "undefined")){
        //The {0} Must Exist.
        Common.alert("<spring:message code='sys.msg.Exists' arguments='UserDFN#25 Desc' htmlEscape='false'/>");
        return false;
    }

     gAddRowCnt = 0;
     Common.ajax("POST", "/program/updateTrans.do"
        , GridCommon.getEditData(transGridID)
        , function(result)
         {
            Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
            fnSelectPgmListAjax() ;
            fnSelectPgmTransListAjax();
            console.log("성공." + JSON.stringify(result));
            console.log("data : " + result.data);
         }
         , function(jqXHR, textStatus, errorThrown)
        {
          try
          {
            console.log("Fail Status : " + jqXHR.status);
            console.log("code : "        + jqXHR.responseJSON.code);
            console.log("message : "     + jqXHR.responseJSON.message);
            console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
          }
          catch (e)
          {
            console.log(e);
          }
          alert("Fail : " + jqXHR.responseJSON.message);
        });
}

//셀스타일 함수 정의
function cellStyleFunction(rowIndex, columnIndex, value, headerText, item, dataField)
{
    if(value != null)
    {
      return "aui-grid-left-column";
    }
    else
    {
        return null;
    }
}

//칼럼 숨김/해제 체크박스 핸들러
function checkboxPgmIdChangeHandler(event)
{
  if (event == "show")
  {
      AUIGrid.showColumnByDataField(myGridID, "pgmCode");
      AUIGrid.hideColumnByDataField(myGridID, "orgCode");
  }
  else  // hide
  {
      AUIGrid.hideColumnByDataField(myGridID, "pgmCode");
      AUIGrid.showColumnByDataField(myGridID, "orgCode");
  }

}

function fnTransGridReset()
{
    gAddRowCnt = 0;
  AUIGrid.clearGridData(transGridID);
  $("#transGrid").find(".aui-grid-nodata-msg-layer").remove();
}

// 삭제해서 마크 된(줄이 그어진) 행을 복원 합니다.(삭제 취소)
function removeAllCancel()
{
    $("#delCancel").hide();

    AUIGrid.restoreSoftRows(myGridID, "all");
}


function fnClear()
{
}

function fnSelectTransGrid(tGrid, mGrid, evntRowIdx)
{
    var  jcnt = 5;  //view start.

    for (var icnt = 0 ; icnt < 14; icnt++)
    {
      AUIGrid.setCellValue(tGrid, 0, icnt, AUIGrid.getCellValue(mGrid, evntRowIdx, jcnt));
      if (icnt == 13)
      {
          AUIGrid.setCellValue(tGrid, 0, icnt, AUIGrid.getCellValue(mGrid, evntRowIdx, 0))
      }
      jcnt++ ;
    }
}

var myGridID, transGridID;
var oldRowIndex = -1;

$(document).ready(function()
{
    $("#pgmCode").focus();

     $("#pgmCode").keydown(function(key)
     {
        if (key.keyCode == 13)
        {
           fnSelectPgmListAjax();
        }
     });
    $("#pgmCode").bind("keyup", function()
    {
      $(this).val($(this).val().toUpperCase());
    });
    $("#pgmNm").keydown(function(key)
    {
       if (key.keyCode == 13)
       {
           fnSelectPgmListAjax();
       }
    });

    $("#pgmNm").bind("keyup", function()
    {
      $(this).val($(this).val().toUpperCase());
    });

    fn_commCodeSearch(); // 공통코드 호출

    var options = {
                  usePaging : true,
                  useGroupingPanel : false,
                  showRowNumColumn : false, // 순번 칼럼 숨김
                  // 셀 병합 실행
                  enableCellMerge : true,
                  editBeginMode : "click", // 편집모드 클릭
                  selectionMode : "multipleRows",
                  // 셀머지된 경우, 행 선택자(selectionMode : singleRow, multipleRows) 로 지정했을 때 병합 셀도 행 선택자에 의해 선택되도록 할지 여부
                  rowSelectionWithMerge : true,
                  softRemovePolicy : "exceptNew", //사용자추가한 행은 바로 삭제
                  editable : true
                };


    var MainColumnLayout =
        [
            {
                dataField : "pgmCode",
                headerText : "<spring:message code='sys.progmanagement.grid1.Id'/>",
                editable : false,
                width : "5%",
            }, {
                dataField : "orgCode",
                headerText : "<spring:message code='sys.progmanagement.grid1.OrgCode'/>",
                style : "aui-grid-left-column",
                headerStyle : "aui-grid-header-input-icon aui-grid-header-input-essen", // 20190910 KR-MIN : aui-grid-header-input-icon: input, aui-grid-header-input-essen: Mandatory indication
                visible : false,
                editRenderer : {
                    type : "DropDownListRenderer",
                    showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                    list : gOrgList
                },
                width : "10%",
            },{
                dataField : "pgmName",
                headerText : "<spring:message code='sys.generalCode.grid1.NAME'/>",
                headerStyle : "aui-grid-header-input-icon aui-grid-header-input-essen",
                style : "aui-grid-left-column",
                width : "15%",
            }, {
                dataField : "pgmPath",
                headerText : "<spring:message code='sys.progmanagement.grid1.Path'/>",
                headerStyle : "aui-grid-header-input-icon aui-grid-header-input-essen",
                styleFunction : cellStyleFunction,
                width : "25%",
            }, {
                dataField : "pgmDesc",
                headerText : "<spring:message code='sys.progmanagement.grid1.Description'/>",
                headerStyle : "aui-grid-header-input-icon",
                style : "aui-grid-left-column",
                width : "15%",
            }, {
                dataField : "fromDtTypeId", // 20190902 KR-OHK : FromDtTypeId add
                headerText : "<spring:message code='sys.progmanagement.grid1.FromDtTypeId'/>",
                headerStyle : "aui-grid-header-input-icon",
                style : "aui-grid-left-column",
                labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
                    var retStr = value;
                    for(var i=0,len=keyValueList.length; i<len; i++) {
                            if(keyValueList[i]["codeId"] == value) {
                            retStr = keyValueList[i]["codeName"];
                            break;
                        }
                    }
                    return retStr;
                },
                editRenderer : {
                    type : "DropDownListRenderer",
                    showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                    list : keyValueList, //key-value Object 로 구성된 리스트
                    keyField : "codeId", // key 에 해당되는 필드명
                    valueField : "codeName", // value 에 해당되는 필드명
                    listAlign : "left"
                },
                width : "10%"
            }, {
                dataField : "fromDtFieldNm", // 20190902 KR-OHK : FromDtFieldNm add
                headerText : "<spring:message code='sys.progmanagement.grid1.FromDtFieldNm'/>",
                headerStyle : "aui-grid-header-input-icon",
                style : "aui-grid-left-column",
                width : "10%",
                editRenderer : {
                    type : "InputEditRenderer",
                    // 에디팅 유효성 검사
                    validator : function(oldValue, newValue, item, dataField) {
                        var isValid = true;
                        var rtnMsg = "";
                        var matcher = /^[_a-zA-Z0-9]+$/;

                        if(newValue.length > 0) {
                            if(!matcher.test(newValue)) {
                                isValid = false;
                                rtnMsg = "Invaild character.";
                            }
                            if(newValue.length > 20) {
                                isValid = false;
                                rtnMsg = "The maximum of characters is 20.";
                            }
                        }

                        // 리턴값은 Object 이며 validate 의 값이 true 라면 패스, false 라면 message 를 띄움
                        return { "validate" : isValid, "message"  : rtnMsg };
                    }
                }
            } , {
                dataField : "fromDtVal",  // 20190902 KR-OHK : FromDtVal add
                headerText : "<spring:message code='sys.progmanagement.grid1.FromDtVal'/>",
                headerStyle : "aui-grid-header-input-icon",
                style : "aui-grid-left-column",
                width : "8%",
                editRenderer : {
                    type : "InputEditRenderer",
                    // 에디팅 유효성 검사
                    validator : function(oldValue, newValue, item, dataField) {
                        var isValid = true;
                        var rtnMsg = "";
                        var matcher = /^(0|-?[1-9][0-9]*)$/;

                        if(newValue.length > 0) {
                            if(!matcher.test(newValue)) {
                                isValid = false;
                                rtnMsg = "Invaild character.";
                            }
                            if(newValue.length > 10) {
                                isValid = false;
                                rtnMsg = "The maximum of characters is 10.";
                            }
                        }
                        // 리턴값은 Object 이며 validate 의 값이 true 라면 패스, false 라면 message 를 띄움
                        return { "validate" : isValid, "message"  : rtnMsg };
                    }
                }
            }, {
                dataField : "toDtTypeId", // 20190902 KR-OHK : ToDtTypeId add
                headerText : "<spring:message code='sys.progmanagement.grid1.ToDtTypeId'/>",
                headerStyle : "aui-grid-header-input-icon",
                style : "aui-grid-left-column",
                labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
                    var retStr = value;
                    for(var i=0,len=keyValueList.length; i<len; i++) {
                        if(keyValueList[i]["codeId"] == value) {
                            retStr = keyValueList[i]["codeName"];
                            break;
                        }
                    }
                    return retStr;
                },
                editRenderer : {
                    type : "DropDownListRenderer",
                    showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                    list : keyValueList, //key-value Object 로 구성된 리스트
                    keyField : "codeId", // key 에 해당되는 필드명
                    valueField : "codeName", // value 에 해당되는 필드명
                    listAlign : "left"
                },
                width : "10%"
            }, {
                dataField : "toDtFieldNm", // 20190902 KR-OHK : ToDtFieldNm add
                headerText : "<spring:message code='sys.progmanagement.grid1.ToDtFieldNm'/>",
                headerStyle : "aui-grid-header-input-icon",
                style : "aui-grid-left-column",
                width : "10%",
                editRenderer : {
                    type : "InputEditRenderer",
                    // 에디팅 유효성 검사
                    validator : function(oldValue, newValue, item, dataField) {
                        var isValid = true;
                        var rtnMsg = "";

                        var matcher = /^[_a-zA-Z0-9]+$/;

                        if(newValue.length > 0) {
                            if(!matcher.test(newValue)) {
                                isValid = false;
                                rtnMsg = "Invaild character.";
                            }
                            if(newValue.length > 20) {
                                isValid = false;
                                rtnMsg = "The maximum of characters is 20.";
                            }
                        }

                        // 리턴값은 Object 이며 validate 의 값이 true 라면 패스, false 라면 message 를 띄움
                        return { "validate" : isValid, "message"  : rtnMsg };
                    }
                }
            }
            , {
                dataField : "toDtVal", // 20190902 KR-OHK : ToDtVal add
                headerText : "<spring:message code='sys.progmanagement.grid1.ToDtVal'/>",
                headerStyle : "aui-grid-header-input-icon",
                style : "aui-grid-left-column",
                width : "8%",
                editRenderer : {
                    type : "InputEditRenderer",
                    // 에디팅 유효성 검사
                    validator : function(oldValue, newValue, item, dataField) {
                        var isValid = true;
                        var rtnMsg = "";
                        var matcher = /^(0|-?[1-9][0-9]*)$/;

                        if(newValue.length > 0) {
                            if(!matcher.test(newValue)) {
                                isValid = false;
                                rtnMsg = "Invaild character.";
                            }
                            if(newValue.length > 10) {
                                isValid = false;
                                rtnMsg = "The maximum of characters is 10.";
                            }
                        }

                        // 리턴값은 Object 이며 validate 의 값이 true 라면 패스, false 라면 message 를 띄움
                        return { "validate" : isValid, "message"  : rtnMsg };
                    }
                }
            }
        ];

    // masterGrid 그리드를 생성합니다.
    myGridID = GridCommon.createAUIGrid("grid_wrap", MainColumnLayout,"", options);
    // AUIGrid 그리드를 생성합니다.

    // 20190902 KR-OHK : Add selectionChange event
    AUIGrid.bind(myGridID, "selectionChange", function(event) {
        var selectedItems = event.selectedItems;
        if(selectedItems.length <= 0) return;
        var firstItem = selectedItems[0];

        var primeCell = event.primeCell; // 선택된 대표 셀
        var rowIndex = primeCell.rowIndex;

        if(firstItem.rowIndex != oldRowIndex) {
             $("#paramPgmId").val("");
            fnTransGridReset();

            fnSetPgmIdParamSet(myGridID, rowIndex);
            fnSelectPgmTransListAjax();
        }
        oldRowIndex =  firstItem.rowIndex; // 현재 rowIndex 를 보관하면, 다음 셀렉션 시 비교 할 수 있음.
    });

    // 푸터 객체 세팅
    //AUIGrid.setFooter(myGridID, footerObject);

    // 에디팅 시작 이벤트 바인딩
    AUIGrid.bind(myGridID, "cellEditBegin", auiCellEditignHandler);

    // 에디팅 정상 종료 이벤트 바인딩
    AUIGrid.bind(myGridID, "cellEditEnd", auiCellEditignHandler);

    // 에디팅 취소 이벤트 바인딩
    AUIGrid.bind(myGridID, "cellEditCancel", auiCellEditignHandler);

    // 행 추가 이벤트 바인딩
    AUIGrid.bind(myGridID, "addRow", auiAddRowHandler);

    // 행 삭제 이벤트 바인딩
    AUIGrid.bind(myGridID, "removeRow", auiRemoveRowHandler);

    // cellClick event.
    AUIGrid.bind(myGridID, "cellClick", function( event )
    {
        // 20190902 KR-OHK
        /* $("#paramPgmId").val("");

        fnTransGridReset();

        fnSetPgmIdParamSet(myGridID, event.rowIndex);
        fnSelectPgmTransListAjax();
        console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clickedParamPgmId: " + $("#paramPgmId").val() +" / "+ $("#paramPgmName").val());
        */
    });

    // 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(myGridID, "cellDoubleClick", function(event)
    {
        console.log("DobleClick ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + " value: " + event.value );
    });

    var transOptions =
        {
            usePaging : false,
            editable : true,
         // 셀, 행 수정 후 원본으로 복구 시키는 기능 사용 가능 여부 (기본값:true)
            enableRestore : true,
            showRowNumColumn : false, // 순번 칼럼 숨김
            //툴팁 출력 지정
            showTooltip : true,
            //툴팁 마우스 대면 바로 나오도록 (0), 500mms 이후에 툴립출력(500)
            tooltipSensitivity : 0,
            softRemovePolicy : "exceptNew",
            noDataMessage : null, //"출력할 데이터가 없습니다.",
        };

    // detailGrid 생성
    transGridID = GridCommon.createAUIGrid("transGrid", TransColumnLayout,"", transOptions);

    // 에디팅 시작 이벤트 바인딩
    AUIGrid.bind(transGridID, "cellEditBegin", auiCellEditignHandler);

    // 에디팅 정상 종료 이벤트 바인딩
    AUIGrid.bind(transGridID, "cellEditEnd", auiCellEditignHandler);

    // 에디팅 취소 이벤트 바인딩
    AUIGrid.bind(transGridID, "cellEditCancel", auiCellEditignHandler);

    // 행 추가 이벤트 바인딩
    AUIGrid.bind(transGridID, "addRow", auiAddRowHandler);

    // 행 삭제 이벤트 바인딩
    AUIGrid.bind(transGridID, "removeRow", auiRemoveRowHandlerDetail);

    // cellClick event.
    AUIGrid.bind(transGridID, "cellClick", function( event )
    {
        console.log("transGridID CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " event_value: " + event.value +" header: " + event.headerText  );

        if (event.columnIndex == 3 &&  event.value == "Y")
        {
            AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn1"] );
        }
        else if (event.columnIndex == 3 &&  event.value == "N")
        {
            var myValue_desc1 = AUIGrid.getCellValue(transGridID, 0, 4);

            if(myValue_desc1.length == 0 ){
                AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn1"] );
            }else{
                AUIGrid.setCellValue(transGridID, 0, 4, "");
            }
        }

        if (event.columnIndex == 5 &&  event.value == "Y")
        {
            AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn2"] );
        }
        else if (event.columnIndex == 5 &&  event.value == "N")
        {
            var myValue_desc2 = AUIGrid.getCellValue(transGridID, 0, 6);

            if(myValue_desc2.length == 0 ){
                AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn2"] );
            }else{
                AUIGrid.setCellValue(transGridID, 0, 6, "");
            }
        }

        if (event.columnIndex == 7 &&  event.value == "Y")
        {
            AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn3"] );
        }
        else if (event.columnIndex == 7 &&  event.value == "N")
        {
            //AUIGrid.setCellValue(transGridID, 0, 8, "");
            var myValue_desc3 = AUIGrid.getCellValue(transGridID, 0, 8);

            if(myValue_desc3.length == 0 ){
                AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn3"] );
            }else{
                AUIGrid.setCellValue(transGridID, 0, 8, "");
            }
        }

        if (event.columnIndex == 9 &&  event.value == "Y")
        {
            AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn4"] );
        }
        else if (event.columnIndex == 9 &&  event.value == "N")
        {
            //AUIGrid.setCellValue(transGridID, 0, 10, "");
            var myValue_desc4 = AUIGrid.getCellValue(transGridID, 0, 10);

            if(myValue_desc4.length == 0 ){
                AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn4"] );
            }else{
                AUIGrid.setCellValue(transGridID, 0, 10, "");
            }
        }

        if (event.columnIndex == 11 &&  event.value == "Y")
        {
            AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn5"] );
        }
        else if (event.columnIndex == 11 &&  event.value == "N")
        {
            //AUIGrid.setCellValue(transGridID, 0, 12, "");
            var myValue_desc5 = AUIGrid.getCellValue(transGridID, 0, 12);

            if(myValue_desc5.length == 0 ){
                AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn5"] );
            }else{
                AUIGrid.setCellValue(transGridID, 0, 12, "");
            }
        }

        ///////////////////////////////////////

         if (event.columnIndex == 13 &&  event.value == "Y")
        {
            AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn6"] );
        }
        else if (event.columnIndex == 13 &&  event.value == "N")
        {
            var myValue_desc6 = AUIGrid.getCellValue(transGridID, 0, 14);

            if(myValue_desc6.length == 0 ){
                AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn6"] );
            }else{
                AUIGrid.setCellValue(transGridID, 0, 14, "");
            }
        }

        if (event.columnIndex == 15 &&  event.value == "Y")
        {
            AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn7"] );
        }
        else if (event.columnIndex == 15 &&  event.value == "N")
        {
            var myValue_desc7 = AUIGrid.getCellValue(transGridID, 0, 16);

            if(myValue_desc7.length == 0 ){
                AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn7"] );
            }else{
                AUIGrid.setCellValue(transGridID, 0, 16, "");
            }
        }

        if (event.columnIndex == 17 &&  event.value == "Y")
        {
            AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn8"] );
        }
        else if (event.columnIndex == 17 &&  event.value == "N")
        {
            //AUIGrid.setCellValue(transGridID, 0, 8, "");
            var myValue_desc8 = AUIGrid.getCellValue(transGridID, 0, 18);

            if(myValue_desc8.length == 0 ){
                AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn8"] );
            }else{
                AUIGrid.setCellValue(transGridID, 0, 18, "");
            }
        }

        if (event.columnIndex == 19 &&  event.value == "Y")
        {
            AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn9"] );
        }
        else if (event.columnIndex == 19 &&  event.value == "N")
        {
            //AUIGrid.setCellValue(transGridID, 0, 10, "");
            var myValue_desc9 = AUIGrid.getCellValue(transGridID, 0, 20);

            if(myValue_desc9.length == 0 ){
                AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn9"] );
            }else{
                AUIGrid.setCellValue(transGridID, 0, 20, "");
            }
        }

        if (event.columnIndex == 21 &&  event.value == "Y")
        {
            AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn10"] );
        }
        else if (event.columnIndex == 21 &&  event.value == "N")
        {
            //AUIGrid.setCellValue(transGridID, 0, 12, "");
            var myValue_desc10 = AUIGrid.getCellValue(transGridID, 0, 22);

            if(myValue_desc10.length == 0 ){
                AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn10"] );
            }else{
                AUIGrid.setCellValue(transGridID, 0, 22, "");
            }
        }


        /////////////////////


         if (event.columnIndex == 23 &&  event.value == "Y")
        {
            AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn11"] );
        }
        else if (event.columnIndex == 23 &&  event.value == "N")
        {
            var myValue_desc11 = AUIGrid.getCellValue(transGridID, 0, 24);

            if(myValue_desc11.length == 0 ){
                AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn11"] );
            }else{
                AUIGrid.setCellValue(transGridID, 0, 24, "");
            }
        }

        if (event.columnIndex == 25 &&  event.value == "Y")
        {
            AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn12"] );
        }
        else if (event.columnIndex == 25 &&  event.value == "N")
        {
            var myValue_desc12 = AUIGrid.getCellValue(transGridID, 0, 26);

            if(myValue_desc12.length == 0 ){
                AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn12"] );
            }else{
                AUIGrid.setCellValue(transGridID, 0, 26, "");
            }
        }

        if (event.columnIndex == 27 &&  event.value == "Y")
        {
            AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn13"] );
        }
        else if (event.columnIndex == 27 &&  event.value == "N")
        {
            //AUIGrid.setCellValue(transGridID, 0, 8, "");
            var myValue_desc13 = AUIGrid.getCellValue(transGridID, 0, 28);

            if(myValue_desc13.length == 0 ){
                AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn13"] );
            }else{
                AUIGrid.setCellValue(transGridID, 0, 28, "");
            }
        }

        if (event.columnIndex == 29 &&  event.value == "Y")
        {
            AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn14"] );
        }
        else if (event.columnIndex == 29 &&  event.value == "N")
        {
            //AUIGrid.setCellValue(transGridID, 0, 10, "");
            var myValue_desc14 = AUIGrid.getCellValue(transGridID, 0, 30);

            if(myValue_desc14.length == 0 ){
                AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn14"] );
            }else{
                AUIGrid.setCellValue(transGridID, 0, 30, "");
            }
        }

        if (event.columnIndex == 31 &&  event.value == "Y")
        {
            AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn15"] );
        }
        else if (event.columnIndex == 31 &&  event.value == "N")
        {
            //AUIGrid.setCellValue(transGridID, 0, 12, "");
            var myValue_desc15 = AUIGrid.getCellValue(transGridID, 0, 32);

            if(myValue_desc15.length == 0 ){
                AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn15"] );
            }else{
                AUIGrid.setCellValue(transGridID, 0, 32, "");
            }
        }


        //////////////////////////////



         if (event.columnIndex == 33 &&  event.value == "Y")
        {
            AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn16"] );
        }
        else if (event.columnIndex == 33 &&  event.value == "N")
        {
            var myValue_desc16 = AUIGrid.getCellValue(transGridID, 0, 34);

            if(myValue_desc16.length == 0 ){
                AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn16"] );
            }else{
                AUIGrid.setCellValue(transGridID, 0, 34, "");
            }
        }

        if (event.columnIndex == 35 &&  event.value == "Y")
        {
            AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn17"] );
        }
        else if (event.columnIndex == 35 &&  event.value == "N")
        {
            var myValue_desc17 = AUIGrid.getCellValue(transGridID, 0, 36);

            if(myValue_desc17.length == 0 ){
                AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn17"] );
            }else{
                AUIGrid.setCellValue(transGridID, 0, 36, "");
            }
        }

        if (event.columnIndex == 37 &&  event.value == "Y")
        {
            AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn18"] );
        }
        else if (event.columnIndex == 37 &&  event.value == "N")
        {
            //AUIGrid.setCellValue(transGridID, 0, 8, "");
            var myValue_desc18 = AUIGrid.getCellValue(transGridID, 0, 38);

            if(myValue_desc18.length == 0 ){
                AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn18"] );
            }else{
                AUIGrid.setCellValue(transGridID, 0, 38, "");
            }
        }

        if (event.columnIndex == 39 &&  event.value == "Y")
        {
            AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn19"] );
        }
        else if (event.columnIndex == 39 &&  event.value == "N")
        {
            //AUIGrid.setCellValue(transGridID, 0, 10, "");
            var myValue_desc19 = AUIGrid.getCellValue(transGridID, 0, 40);

            if(myValue_desc19.length == 0 ){
                AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn19"] );
            }else{
                AUIGrid.setCellValue(transGridID, 0, 40, "");
            }
        }

        if (event.columnIndex == 41 &&  event.value == "Y")
        {
            AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn20"] );
        }
        else if (event.columnIndex == 41 &&  event.value == "N")
        {
            //AUIGrid.setCellValue(transGridID, 0, 12, "");
            var myValue_desc20 = AUIGrid.getCellValue(transGridID, 0, 42);

            if(myValue_desc20.length == 0 ){
                AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn20"] );
            }else{
                AUIGrid.setCellValue(transGridID, 0, 42, "");
            }
        }

        if (event.columnIndex == 43 &&  event.value == "Y")
        {
            AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn21"] );
        }
        else if (event.columnIndex == 43 &&  event.value == "N")
        {
            //AUIGrid.setCellValue(transGridID, 0, 12, "");
            var myValue_desc21 = AUIGrid.getCellValue(transGridID, 0, 44);

            if(myValue_desc21.length == 0 ){
                AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn21"] );
            }else{
                AUIGrid.setCellValue(transGridID, 0, 44, "");
            }
        }

        if (event.columnIndex == 45 &&  event.value == "Y")
        {
            AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn22"] );
        }
        else if (event.columnIndex == 45 &&  event.value == "N")
        {
            //AUIGrid.setCellValue(transGridID, 0, 12, "");
            var myValue_desc22 = AUIGrid.getCellValue(transGridID, 0, 46);

            if(myValue_desc22.length == 0 ){
                AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn22"] );
            }else{
                AUIGrid.setCellValue(transGridID, 0, 46, "");
            }
        }

        if (event.columnIndex == 47 &&  event.value == "Y")
        {
            AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn23"] );
        }
        else if (event.columnIndex == 47 &&  event.value == "N")
        {
            //AUIGrid.setCellValue(transGridID, 0, 12, "");
            var myValue_desc23 = AUIGrid.getCellValue(transGridID, 0, 48);

            if(myValue_desc23.length == 0 ){
                AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn23"] );
            }else{
                AUIGrid.setCellValue(transGridID, 0, 48, "");
            }
        }

        if (event.columnIndex == 49 &&  event.value == "Y")
        {
            AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn24"] );
        }
        else if (event.columnIndex == 49 &&  event.value == "N")
        {
            //AUIGrid.setCellValue(transGridID, 0, 12, "");
            var myValue_desc24 = AUIGrid.getCellValue(transGridID, 0, 50);

            if(myValue_desc24.length == 0 ){
                AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn24"] );
            }else{
                AUIGrid.setCellValue(transGridID, 0, 50, "");
            }
        }

        if (event.columnIndex == 51 &&  event.value == "Y")
        {
            AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn25"] );
        }
        else if (event.columnIndex == 51 &&  event.value == "N")
        {
            //AUIGrid.setCellValue(transGridID, 0, 12, "");
            var myValue_desc25 = AUIGrid.getCellValue(transGridID, 0, 52);

            if(myValue_desc25.length == 0 ){
                AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn25"] );
            }else{
                AUIGrid.setCellValue(transGridID, 0, 52, "");
            }
        }
    });

    $("#delCancel").hide();

});   //$(document).ready

</script>

    <section id="content">
      <!-- content start -->
      <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Sales</li>
        <li>Order list</li>
      </ul>

      <aside class="title_line">
        <!-- title_line start -->
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>Program Management</h2>
        <ul class="right_btns">
          <li>
            <p class="btn_blue"><a onclick="fnSelectPgmListAjax();"><span class="search"></span>Search</a></p>
          </li>
          <!-- <li><p class="btn_blue"><a onclick="fnClear();"><span class="clear"></span>Clear</a></p></li> -->
        </ul>
      </aside><!-- title_line end -->


      <section class="search_table">
        <!-- search_table start -->
        <form id="MainForm" method="get" action="">
          <input type="hidden" id="paramPgmId" name="paramPgmId" value="" />
          <input type="hidden" id="paramPgmName" name="paramPgmName" value="" />


          <table class="type1">
            <!-- table start -->
            <caption>table</caption>
            <colgroup>
              <col style="width:150px" />
              <col style="width:*" />
              <!--   <col style="width:150px" />
  <col style="width:*" /> -->
            </colgroup>
            <tbody>
              <tr>
                <th scope="row">Program</th>
                <td>
                  <input type="text" title="" id="pgmCode" name="pgmCode" placeholder="Program Id or Name" class="" />

                  <input type="text" title="" id="hiddenInput" name="hiddenInput" placeholder="hiddenInput"
                    style="display:none;" class="" />
                </td>
                <!-- <th scope="row">Name</th>
  <td>
  <input type="text" title="" id="pgmNm" name="pgmNm" placeholder="program name" class="w100p" />
  </td> -->
              </tr>
            </tbody>
          </table><!-- table end -->

          <aside class="link_btns_wrap">
            <!-- link_btns_wrap start -->
            <p class="show_btn">
              <%-- <a href="javascript:void(0);">
                <img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" />
                </a> --%>
            </p>
        </form>
      </section><!-- search_table end -->

      <section class="search_result">
        <!-- search_result start -->

        <aside class="title_line">
          <!-- title_line start -->
          <h3 class="pt0">Program List</h3>
          <ul class="right_opt">
            <li id="delCancel">
              <p class="btn_grid"><a onclick="removeAllCancel();">Cancel</a></p>
            </li>
            <li>
              <p class="btn_grid"><a onclick="removeRow();">DEL</a></p>
            </li>
            <li>
              <p class="btn_grid"><a onclick="fnAddRowPgmId();">ADD</a></p>
            </li>
            <li>
              <p class="btn_grid"><a onclick="fnSavePgmId();">SAVE</a></p>
            </li>
          </ul>
        </aside><!-- title_line end -->

        <article class="grid_wrap">
          <!-- grid_wrap start -->
          <!-- 그리드 영역 1-->
          <div id="grid_wrap" style="height:290px;"></div>
        </article><!-- grid_wrap end -->


        <aside class="title_line mt20">
          <!-- title_line start -->
          <h3 class="pt0">Transaction</h3>
          <ul class="right_opt">
            <li>
              <p class="btn_grid"><a onclick="fnAddRowTrans();">ADD</a></p>
            </li>
            <li>
              <p class="btn_grid"><a onclick="fnUpdateTrans();">SAVE</a></p>
            </li>
          </ul>
        </aside><!-- title_line end -->

        <article class="grid_wrap">
          <!-- grid_wrap start -->
          <!-- 그리드 영역2 -->
          <div id="transGrid" class="autoGridHeight"></div>
        </article><!-- grid_wrap end -->

      </section><!-- search_result end -->

    </section><!-- content end -->