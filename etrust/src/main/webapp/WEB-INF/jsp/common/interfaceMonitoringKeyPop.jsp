<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script type="text/javaScript">
/********************************Global Variable Start***********************************/
var grdIfKey = "";
/********************************Global Variable End************************************/
/********************************Function  Start***************************************
 *
 */

/****************************Function  End***********************************
 *
 */
/****************************Transaction Start********************************/

function fn_searchKeyPop(){
   var selectedRow = AUIGrid.getSelectedItems(grdIfDtm);

   Common.ajax(
           "GET",

           "/common/selectInterfaceMonitoringKeyList.do",

           "fromTable=GBSLCVD.ITF0001D_TEMP&toTable=ZCOMT_IF000"+
           "&selectDate="+selectedRow[0].item.rgstDt.replace(/-/g,"")+
           "&ifType="+selectedRow[0].item.ifType,

           function(data, textStatus, jqXHR){ // Success
               AUIGrid.clearGridData(grdIfKey);
               AUIGrid.setGridData(grdIfKey, data);
           },

           function(jqXHR, textStatus, errorThrown){ // Error
               alert("Fail : " + jqXHR.responseJSON.message);
           }
   )
};
/****************************Transaction End********************************/
/**************************** Grid setting Start ********************************/
var gridIfKeyColumnLayout =
    [
     /* PK , rowid 용 칼럼*/
     {
         dataField : "rowId",
         dataType : "string",
          visible : false
     },
     {
         dataField : "ifType",
         headerText : "IF TYPE",
         width:"7%",
         editRenderer : {
             type : "InputEditRenderer",

             // 에디팅 유효성 검사
             validator : function(oldValue, newValue, item, dataField) {
                 var isValid = false;

                 if(newValue.length <= 5) {
                     isValid = true;
                 }

                 // 리턴값은 Object 이며 validate 의 값이 true 라면 패스, false 라면 message 를 띄움
                 return { "validate" : isValid, "message"  : "The maximum of characters is 5 "};
             }
         }
     },
     {
         dataField : "ifKey",
         headerText : "IF KEY",
         width:"18%",
         editRenderer : {
             type : "InputEditRenderer",

             // 에디팅 유효성 검사
             validator : function(oldValue, newValue, item, dataField) {
                 var isValid = false;

                 if(newValue.length <= 5) {
                     isValid = true;
                 }

                 // 리턴값은 Object 이며 validate 의 값이 true 라면 패스, false 라면 message 를 띄움
                 return { "validate" : isValid, "message"  : "The maximum of characters is 5 "};
             }
         }
     },
     {
         dataField : "seq",
         headerText : "SEQ",
         width:"5%",
         editRenderer : {
             type : "InputEditRenderer",

             // 에디팅 유효성 검사
             validator : function(oldValue, newValue, item, dataField) {
                 var isValid = false;

                 if(newValue.length <= 5) {
                     isValid = true;
                 }

                 // 리턴값은 Object 이며 validate 의 값이 true 라면 패스, false 라면 message 를 띄움
                 return { "validate" : isValid, "message"  : "The maximum of characters is 5 "};
             }
         }
     },
     {
         dataField : "rgstDt",
         headerText : "Regist Date",
         width:"20%",
         editRenderer : {
             type : "InputEditRenderer",

             // 에디팅 유효성 검사
             validator : function(oldValue, newValue, item, dataField) {
                 var isValid = false;

                 if(newValue.length <= 5) {
                     isValid = true;
                 }

                 // 리턴값은 Object 이며 validate 의 값이 true 라면 패스, false 라면 message 를 띄움
                 return { "validate" : isValid, "message"  : "The maximum of characters is 5 "};
             }
         }
     },
     {
         dataField : "errCd",
         headerText : "Error",
         width:"7%",
         editRenderer : {
             type : "InputEditRenderer",

             // 에디팅 유효성 검사
             validator : function(oldValue, newValue, item, dataField) {
                 var isValid = false;

                 if(newValue.length <= 5) {
                     isValid = true;
                 }

                 // 리턴값은 Object 이며 validate 의 값이 true 라면 패스, false 라면 message 를 띄움
                 return { "validate" : isValid, "message"  : "The maximum of characters is 5 "};
             }
         }
     },
     {
        dataField : "errMsg",
        headerText : "Error Msg",
        width : "20%",
        style : "aui-grid-user-custom-left",
        editRenderer : {
            type : "InputEditRenderer",

            // 에디팅 유효성 검사
            validator : function(oldValue, newValue, item, dataField) {
                var isValid = false;

                if(newValue.length <= 200) {
                    isValid = true;
                }
                // 리턴값은 Object 이며 validate 의 값이 true 라면 패스, false 라면 message 를 띄움
                return { "validate" : isValid, "message"  : "The maximum of characters is 200 "};
            }
        }
    },
     {
         dataField : "chkCol",
         headerText : "Check Col",
         width:"7%",
         editRenderer : {
             type : "InputEditRenderer",

             // 에디팅 유효성 검사
             validator : function(oldValue, newValue, item, dataField) {
                 var isValid = false;

                 if(newValue.length <= 5) {
                     isValid = true;
                 }

                 // 리턴값은 Object 이며 validate 의 값이 true 라면 패스, false 라면 message 를 띄움
                 return { "validate" : isValid, "message"  : "The maximum of characters is 5 "};
             }
         }
     },
    {
       dataField : "tranStatusCd",
       headerText : "Status",
       width : "8%",
       editRenderer : {
           type : "InputEditRenderer",

           // 에디팅 유효성 검사
           validator : function(oldValue, newValue, item, dataField) {
               var isValid = false;

               if(newValue.length <= 30) {
                   isValid = true;
               }
               // 리턴값은 Object 이며 validate 의 값이 true 라면 패스, false 라면 message 를 띄움
               return { "validate" : isValid, "message"  : "The maximum of characters is 200 "};
           }
       }
   },
   {
      dataField : "tranStatusNm",
      headerText : "Status Name",
      width : "12%",
      style : "aui-grid-user-custom-left",
      editRenderer : {
          type : "InputEditRenderer",

          // 에디팅 유효성 검사
          validator : function(oldValue, newValue, item, dataField) {
              var isValid = false;

              if(newValue.length <= 30) {
                  isValid = true;
              }
              // 리턴값은 Object 이며 validate 의 값이 true 라면 패스, false 라면 message 를 띄움
              return { "validate" : isValid, "message"  : "The maximum of characters is 200 "};
          }
      }
  },
   {
      dataField : "sndChkVal",
      headerText : "Send Check Value",
      width : "15%",
      style : "aui-grid-user-custom-right",
      editRenderer : {
          type : "InputEditRenderer",

          // 에디팅 유효성 검사
          validator : function(oldValue, newValue, item, dataField) {
              var isValid = false;

              if(newValue.length <= 30) {
                  isValid = true;
              }
              // 리턴값은 Object 이며 validate 의 값이 true 라면 패스, false 라면 message 를 띄움
              return { "validate" : isValid, "message"  : "The maximum of characters is 200 "};
          }
      }
    },
    {
        dataField : "rcvChkVal",
        headerText : "Receive Check Value",
        width : "15%",
        style : "aui-grid-user-custom-right",
        editRenderer : {
            type : "InputEditRenderer",

            // 에디팅 유효성 검사
            validator : function(oldValue, newValue, item, dataField) {
                var isValid = false;

                if(newValue.length <= 30) {
                    isValid = true;
                }
                // 리턴값은 Object 이며 validate 의 값이 true 라면 패스, false 라면 message 를 띄움
                return { "validate" : isValid, "message"  : "The maximum of characters is 200 "};
            }
        }
      },
    {
        dataField : "bizCol",
        headerText : "BIZ Column",
        width : "10%",
        editRenderer : {
            type : "InputEditRenderer",

            // 에디팅 유효성 검사
            validator : function(oldValue, newValue, item, dataField) {
                var isValid = false;

                if(newValue.length <= 30) {
                    isValid = true;
                }
                // 리턴값은 Object 이며 validate 의 값이 true 라면 패스, false 라면 message 를 띄움
                return { "validate" : isValid, "message"  : "The maximum of characters is 30 "};
            }
        }
    },
    {
        dataField : "bizVal",
        headerText : "Biz Value",
        style : "aui-grid-user-custom-right",
        editRenderer : {
            type : "InputEditRenderer",

            // 에디팅 유효성 검사
            validator : function(oldValue, newValue, item, dataField) {
                var isValid = false;

                if(newValue.length <= 100) {
                    isValid = true;
                }
                // 리턴값은 Object 이며 validate 의 값이 true 라면 패스, false 라면 message 를 띄움
                return { "validate" : isValid, "message"  : "The maximum of characters is 100 "};
            }
        }
    }
];

//selectionMode (String) : 설정하고자 하는 selectionMode(유효값 : singleCell, singleRow, multipleCells, multipleRows, none)

var optionsKeyPop =
{
        editable : false,
        usePaging : true, //페이징 사용
        useGroupingPanel : false, //그룹핑 숨김
        showRowNumColumn : false, // 순번 칼럼 숨김
        applyRestPercentWidth  : false,
        rowIdField : "rowId", // PK행 지정
        selectionMode : "singleRow",
        editBeginMode : "click", // 편집모드 클릭
        /* aui 그리드 체크박스 옵션*/
        softRemovePolicy : "exceptNew" //사용자추가한 행은 바로 삭제
};

/****************************Program Init Start********************************/
$(document).ready(function(){
    // AUIGrid 그리드를 생성
    grdIfKey = GridCommon.createAUIGrid("grdIfKey", gridIfKeyColumnLayout,"", optionsKeyPop);

    fn_searchKeyPop();

});
/****************************Program Init End********************************/
</script>

<div id="popup_wrap" class="popup_wrap size_large"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1>Interface Monitoring Key</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form id="searchIfKeyForm" action="#" method="post">

<div class="search_100p"><!-- search_100p start -->
<a onclick="fn_searchKeyPop()" class="search_btn"><img src="/resources/images/common/normal_search.gif" alt="search" /></a>
</div><!-- search_100p end -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grdIfKey" style="height:400px;"></div>
</article><!-- grid_wrap end -->
</form>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->