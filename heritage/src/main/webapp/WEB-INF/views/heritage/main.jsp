<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <!DOCTYPE HTML>
    <html>
        <head>
            <title>문화재 상세주소 서비스</title>
            <meta charset="utf-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
               
            <link rel="stylesheet" href="/resources/assets/css/main.css" />
            <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>

            <!-- Font Awesome -->
            <link
            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css"
            rel="stylesheet"
            />
            <!-- Google Fonts -->
            <link
            href="https://fonts.googleapis.com/css?family=Roboto:300,400,500,700&display=swap"
            rel="stylesheet"
            />
            <!-- MDB -->
            <link
            href="https://cdnjs.cloudflare.com/ajax/libs/mdb-ui-kit/3.6.0/mdb.min.css"
            rel="stylesheet"
            />

            <!-- MDB -->
            <script type="text/javascript"
            src="https://cdnjs.cloudflare.com/ajax/libs/mdb-ui-kit/3.6.0/mdb.min.js"
            ></script>

            <style>
                html, body{
                    height: 100%;
                    width: 100%;
                }

                ::-webkit-scrollbar {
                width: 10px;
                }
                
                ::-webkit-scrollbar-track {
                background: rgba(255,255,255,0);
                border-radius: 5px;;
                }
                
                ::-webkit-scrollbar-thumb {
                background: linear-gradient(#c2e59c, #64b3f4);
                border-radius: 5px;
                }

                .overlay_info div, :after, :before {
                 -webkit-box-sizing: unset;
                 box-sizing: unset;
                 border: unset;
                }

                .overlay_info {border-radius: 6px; margin: -12px -5px 0px -5px; float:left;position: relative; border: 1px solid #fff; border-bottom: 2px solid #fff;background-color:#fff; -webkit-box-sizing: unset; box-sizing: unset;}
                .overlay_info:nth-of-type(n) {border:0; box-shadow: 0px 1px 2px #888;}
                .overlay_info a {display: block; background: #64b3f4; background: #64b3f4 url(https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/arrow_white.png) no-repeat right 14px center; text-decoration: none; color: #fff; padding:12px 36px 12px 14px; font-size: 10px; border-radius: 6px 6px 0 0; white-space: nowrap;}
                .overlay_info a strong {color: #fff; padding-left: 5px; font-size: 14px; font-weight: 200;}
                .overlay_info .desc {padding:10px;position: relative; min-width: 190px; height: 56px}
                .overlay_info img {vertical-align: top; width: 56px; height: 56px; object-fit: cover;}
                .overlay_info .address {font-size: 12px; color: #333; position: absolute; left: 80px; right: 14px; top: 10px; white-space: normal}
                .overlay_info:after {content:'';position: absolute; margin-left: -11px; left: 50%; bottom: -12px; width: 22px; height: 12px; background:url(https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/vertex_white.png) no-repeat 0 bottom;}

                /*Css to target the dropdownbox*/
                ul.ui-autocomplete {
                    overflow: hidden;
                    font-size: 0.8em;
                }
                
            </style>
            
        </head>
        <body class="is-preload">

            <!-- alert 창 디자인 -->
            <script src="https://cdn.jsdelivr.net/npm/sweetalert2@9"></script>

            <!-- Header -->
                <div id="header" style="width: 30%; float: left;">
    
                    <div class="top">
    
                    <!--
                        <hr style="color: #6bc010; height:2px; margin: 20px 30px 0px 30px;">

                    
                        <div id="logo">
                            <h1 id="title"">문화재 상세주소 서비스</h1>
                            <p>Cultural Heritage Detailed Address Service</p>
                        </div>
                    -->
                    
                        <div style="background-color: #64b3f4; padding:30px 0px 30px 0px">
                            <div id="logo" style="margin: 0px 30px 24px 30px;">
                                <div  style="float: left;">
                                    <img src="/resources/images/logo.png" style="width: 50px; height: auto;">
                                </div>
                                <div style="float: right;">
                                    <h1 id="title" style="color: white;">문화재 사물주소 안내 서비스</h1>
                                    <p style="color: white;">Cultural Heritage AoT Service</p>
                                </div> 
                            </div>

                            <div id="search" style="margin: 0px 30px 0px 30px;"">
                                <div class="input-group rounded">
                                    <input type="search" id="searchWord" class="form-control rounded" placeholder="문화재를 입력하세요. (예시 : 경복궁)" aria-label="Search"
                                    aria-describedby="search-addon" onkeyup="enterSearch()" style="border: 3px solid #2d80c4; height: 50px; padding:10px;"/>
                                </div>
                            </div>
                        </div>
                    </div>

                        <!--
                        <hr style="color: #6bc010; height:2px; margin: 20px 30px 10px 30px;">
                        -->

                    <div id="bottomResult">

                        <div style="margin: 10px 0px 10px 0px;">
                            <span id="resultCount" style="text-align: center; color: black; margin: 0px 30px 0px 30px; font-size: 0.8em;"></span>
                        </div>

                        <div  style="margin: 10px 30px 30px 30px;">
                            <ul id="heritageList" class="list-group">
                            </ul>
                        </div>
    
                    </div>
  
                </div>
    
            <!-- Main -->
                <div id="main" style="height: 100%; width: 70%; float:right; margin:0;"></div>

                <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=6c83b812ba7b8d29c856df5598527c46"></script>
                <script>
                    var mapContainer = document.getElementById('main'), // 지도를 표시할 div 
                        mapOption = { 
                            center: new kakao.maps.LatLng(37.579512, 126.977019), // 지도의 중심좌표
                            level: 3 // 지도의 확대 레벨
                        };  
                    
                    var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다

                    /*
                    // 일반 지도와 스카이뷰로 지도 타입을 전환할 수 있는 지도타입 컨트롤을 생성합니다
                    var mapTypeControl = new kakao.maps.MapTypeControl();
                    // kakao.maps.ControlPosition은 컨트롤이 표시될 위치를 정의하는데 TOPRIGHT는 오른쪽 위를 의미합니다
                    map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
                    */

                    // 지도 확대 축소를 제어할 수 있는  줌 컨트롤을 생성합니다
                    var zoomControl = new kakao.maps.ZoomControl();
                    map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);

                    // 지도가 확대 또는 축소되면 마지막 파라미터로 넘어온 함수를 호출하도록 이벤트를 등록합니다
                    kakao.maps.event.addListener(map, 'zoom_changed', function() {        
                        
                        // 지도의 현재 레벨을 얻어옵니다
                        var level = map.getLevel();                    
                    });             
                    
                    //바운드를 위한 포인트
                    var points = [];

                    // 지도를 재설정할 범위정보를 가지고 있을 LatLngBounds 객체를 생성합니다
                    var bounds;   
                </script>

                <script type="text/javascript">
                    $(document).ready(function(){

                        //자동완성 기능
                        var allList = [];
                        //문화재 전체 불러오기
                        var loadHeritageString = '"${heritageList}"/>';
                        var loadHeritageList = loadHeritageString.split('heritageName=');
                        for(var i=1; i<loadHeritageList.length; i++)
                        {
                            allList.push(loadHeritageList[i].split(`), HeritageVO`)[0]);
                        }

                        //자동완성 기능
                        $(function () {	//화면 로딩후 시작
                            $("#searchWord").autocomplete({  //오토 컴플릿트 시작
                                source: function(request, response) {
                                        var results = $.ui.autocomplete.filter(allList, request.term);        
                                        response(results.slice(0, 10));
                                    },	// source는 data.js파일 내부의 List 배열
                                focus : function(event, ui) { // 방향키로 자동완성단어 선택 가능하게 만들어줌	
                                    return false;
                                },
                                minLength: 1,// 최소 글자수
                                delay: 100,	//autocomplete 딜레이 시간(ms)
                                //disabled: true, //자동완성 기능 끄기
                            });
                        });

                        //리스트그룹의 아이템을 클릭하면
                        $('#heritageList').on('click', '.list-group-item', function(e) {
                            var selectedItem = $(this).text().split('   ')[1];
  
                            heritageOnMap(selectedItem);
                        });
                    });

                    function setBounds(){
                        for(var i = 0; i < points.length; i++)
                        {
                            bounds.extend(points[i]);
                        }

                        // LatLngBounds 객체에 추가된 좌표들을 기준으로 지도의 범위를 재설정합니다
                        // 이때 지도의 중심좌표와 레벨이 변경될 수 있습니다
                        map.setBounds(bounds);
                    }

                    function refreshSymbol()
                    {
                        //지도에 있는 도형 지우기
                        if(polygons != null)
                        {
                            for(var i=0; i<polygons.length; i++)
                            {
                                polygons[i].setMap(null);
                            }
                            polygons = [];
                        }

                        //마커 지우기
                        if(markers != null)
                        {
                            for(var i=0; i<markers.length; i++)
                            {
                                markers[i].setMap(null);
                            }
                            markers = [];
                        }

                        //정보창 지우기
                        if(infoWindows != null)
                        {
                            infoWindows = [];
                        }

                        //포인트 초기화
                        if(points != null)
                        {
                            points = [];
                        }

                        //바운드 초기화
                        bounds = new kakao.maps.LatLngBounds();
                    }

                    //폴리곤 배열
                    var polygons = [];
                    //마커 배열
                    var markers = [];
                    //마커 정보 창
                    var infoWindows = [];

                    //검색창에서 엔터하면
                    let enterSearch
                    (function($){
                        enterSearch = () => {
                            if(window.event.keyCode == 13){
                                //자동완성 창 닫기
                                document.getElementById('searchWord').blur();

                                closeAllInfoWindows();
                                refreshSymbol();
                                searchHeritage();
                            }
                        }
                    })(jQuery)

                    //카운트를 위한 변수
                    var gb = 0;
                    var bm = 0;
                    var sj = 0;
                    var ms = 0;
                    var cy = 0;

                    function searchHeritage()
                    {
                        //검색어를 입력하지 않았을 때
                        if($('#searchWord').val().trim() == 0)
                        {
                            Swal.fire('검색어를 입력하세요.');
                            return
                        }

                        $('#heritageList').children().remove();

                        //검색결과 가져오기
                        $.ajax({
                            url: "loadList",
                            type: "GET",
                            data: {name: $('#searchWord').val().trim()},
                            dataType:"JSON",
                            success: function(data){
                                //인풋창으로 포커스 이동
                                $("#searchWord").focus();

                                //포인트 초기화
                                points = []

                                showHeritageList(data);
                                makemarkers(data);

                                //결과 카운트 출력
                                document.getElementById("resultCount").innerHTML = '국보 : ' + gb + '점 / 보물 : ' + bm + '점 / 사적 : ' + sj + '곳 / 명승 : ' + ms + '곳 / 천연기념물 : ' + cy + '곳';
                                
                                //검색 결과가 없을 때
                                if(data.length == 0)
                                {
                                    return;
                                }

                                //바운드 조절
                                setBounds();
                            },
                            error: function(request, status, error){
                                alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error); 
                            }
                        });
                    }
                    
                    //마커 만들기
                    function makemarkers(data)
                    {
                        var positions = [];

                        // 마커 이미지의 이미지 주소입니다
                        var imageSrc = "https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png"; 
                        // 마커 이미지의 이미지 크기 입니다
                        var imageSize = new kakao.maps.Size(24, 35); 
                        // 마커 이미지를 생성합니다    
                        var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize); 

                        //카운트 초기화
                        gb = 0;
                        bm = 0;
                        sj = 0;
                        ms = 0;
                        cy = 0;                        

                        //검색 결과 수만큼 만들기
                        for(var i=0; i<data.length; i++)
                        {
                            if (data[i]['ITEMNAME'] == "국보")
                            {gb++}
                            else if(data[i]['ITEMNAME'] == "보물")
                            {bm++}
                            else if(data[i]['ITEMNAME'] == "사적")
                            {sj++}
                            else if(data[i]['ITEMNAME'] == "명승")
                            {ms++}
                            else if(data[i]['ITEMNAME'] == "천연기념물")
                            {cy++}

                            var dataLatlng = data[i]['CENTER'].split('[')[1].split(']')[0].trim();

                            //사물주소가 없다면
                            if(data[i]['AOT'] === undefined)
                            {
                                positions.push(
                                {
                                    content: '<div class="overlay_info">' +
                                            '    <a href="https://www.heritage.go.kr/heri/cul/culSelectDetail.do?VdkVgwKey='
                                            +    data[i]['HERITAGECODE'].substr(0,2) + ',' + data[i]['HERITAGECODE'].substr(2,8) + ',' + data[i]['HERITAGECODE'].substr(10,2)
                                            +    '&pageNo__=5_1_1_0&pageNo=1_1_2_0" target="_blank">'
                                            +    data[i]['ITEMNAME'] + '<strong>'
                                            +    data[i]['HERITAGENAME'] + '</strong></a>' +
                                            '    <div class="desc">' +
                                            '        <img src="' + data[i]['IMAGE'] + '" alt="">' +
                                            '        <span class="address">' + data[i]['ADDRESS'] +'</span>' +
                                            '   </div>' +
                                            '</div>',
                                    latlng : new kakao.maps.LatLng(dataLatlng.split(',')[1].trim(), dataLatlng.split(',')[0].trim())
                                }
                                );
                            }
                            //사물주소가 있다면
                            else{
                                positions.push(
                                {
                                    content: '<div class="overlay_info">' +
                                            '    <a href="https://www.heritage.go.kr/heri/cul/culSelectDetail.do?VdkVgwKey='
                                            +    data[i]['HERITAGECODE'].substr(0,2) + ',' + data[i]['HERITAGECODE'].substr(2,8) + ',' + data[i]['HERITAGECODE'].substr(10,2)
                                            +    '&pageNo__=5_1_1_0&pageNo=1_1_2_0" target="_blank">'
                                            +    data[i]['ITEMNAME'] + '<strong>'
                                            +    data[i]['HERITAGENAME'] + '</strong></a>' +
                                            '    <div class="desc">' +
                                            '        <img src="' + data[i]['IMAGE'] + '" alt="">' +
                                            '        <span class="address">' + data[i]['AOT'] +'</span>' +
                                            '   </div>' +
                                            '</div>',
                                    latlng : new kakao.maps.LatLng(dataLatlng.split(',')[1].trim(), dataLatlng.split(',')[0].trim())
                                }
                                );
                            }

                            points.push(new kakao.maps.LatLng(dataLatlng.split(',')[1].trim(), dataLatlng.split(',')[0].trim()));
                            
                            // 마커를 생성합니다
                            markers.push(new kakao.maps.Marker({
                                map: map, // 마커를 표시할 지도
                                position: positions[i].latlng, // 마커를 표시할 위치
                                image : markerImage // 마커 이미지 
                            }));

                            // 마커에 표시할 인포윈도우를 생성합니다 
                            infoWindows.push(new kakao.maps.InfoWindow({
                                content: positions[i].content // 인포윈도우에 표시할 내용
                            }));

                            kakao.maps.event.addListener(markers[i], 'click', makeClickListener(map, markers[i], infoWindows[i]));
                        }
                    }

                    // 마커를 클릭했을 때 인포윈도우를 표시하는 클로저를 만드는 함수입니다 
                    function makeClickListener(map, marker, infowindow) {
                        return function() {
                            closeAllInfoWindows(); 

                            infowindow.open(map, marker);
                        };
                    }

                    kakao.maps.event.addListener(map, 'click', function(mouseEvent) {
                        closeAllInfoWindows();                        
                    });

                    function closeAllInfoWindows()
                    {
                        for(var i=0; i < infoWindows.length; i++)
                        {
                            infoWindows[i].close();
                        }
                    }
                    
                    //검색 결과 리스트 보여주기
                    function showHeritageList(data)
                    {
                        var heritageList = $('#heritageList');

                        for (var i=0; i<data.length; i++)
                        {
                            heritageList.append('<li id="heritageItem" class="list-group-item list-group-item-action" style="text-align:left; padding:10px; min-height:130px;">'
                                + '<div style="float:left; postion:relative; width: calc(100% - 108px);">'
                                +   '<div style="padding:5px">'
                                +       '<div><span style="color: #03820d; font-size:0.8em; font-weight:bold;">' + data[i]['ITEMNAME'] +'</span>'
                                +                                              '<span id="heritageName" style="color: #1679ca; font-size: 1.1em; font-weight:bold;">   ' + data[i]['HERITAGENAME'] + '</span>'
                                +                                              '<span style="color: black; font-size:0.8em">   ' + data[i]['HERITAGETYPE'] + '</span></div>'
                                +       '<div><span style="color: darkgray; font-size:0.8em">' + data[i]['ADDRESS']
                                +                                               '<br>'+ data[i]['AOT'] +'</span></div>'
                                +   '</div>'
                                + '</div>'
                                + '<div style="float:right; width: 100px; overflow:hidden; verical-align:middle; margin:5px 0px 5px 0px;"><img src="' + data[i]['IMAGE'] + '" alt="" style="display:block; width:100px; height:100px; object-fit:cover; margin:0px; border-radius: 7px;"></div></li>'
                            );                    
                        }                      
                    }

                    function heritageOnMap(selectedItem)
                    {
                        //하나의 결과 가져오기
                        $.ajax({
                            url: "loadOneHeritage",
                            type: "GET",
                            data: {name: selectedItem},
                            dataType:"JSON",
                            success: function(data){
                                closeAllInfoWindows();
                                focusTo(data);
                            },
                            error: function(){
                                alert("error"); 
                            }
                        });
                    }

                    function focusTo(data)
                    {
                        //지도에 있는 도형 지우기
                        if(polygons != null)
                        {
                            for(var i=0; i<polygons.length; i++)
                            {
                                polygons[i].setMap(null);
                            }
                        }

                        refreshSymbol();

                        //마커 만들기
                        makemarkers(data);

                        //폴리곤 가공 및 그리기
                        processPolygon(data);
                    }

                    function processPolygon(data)
                    {
                        var figureType = data[0]['FIGURETYPE'];
                        var center = data[0]['CENTER'];
                        var heritageCoordinate = String(data[0]['COORDINATES']);
                        var coordinateGroup;

                        //멀티폴리곤일 경우
                        if(figureType == "MultiPolygon")
                        {
                            //[ 삭제
                            heritageCoordinate = heritageCoordinate.substr(1, heritageCoordinate.length-1).trim();
                            //] 삭제
                            heritageCoordinate = heritageCoordinate.substr(0, heritageCoordinate.length-1).trim();

                            var groupPolygon = heritageCoordinate.split("[ [ [");

                            for(var i=1; i<groupPolygon.length; i++)
                            {
                                groupPolygon[i] = "[ [ [" + groupPolygon[i];
                                dividePolygon(groupPolygon[i]);
                            }
                        }
                        //일반폴리곤일 경우
                        else if(figureType == "Polygon")
                        {
                            dividePolygon(heritageCoordinate);
                        }

                        //화면 이동하기
                        //moveTo(center);

                        //자동 정보창 열기
                        infoWindows[0].open(map, markers[0]);

                        //화면 이동하기
                        //바운드 조절
                        setBounds();
                    }

                    //일반폴리곤과 구멍있는폴리곤 나누기
                    function dividePolygon(whichPolygon)
                    {
                        //일반폴리곤이라면...
                        if(whichPolygon.split("[ [").length == 2)
                        {
                            whichPolygon = whichPolygon.substr(4, whichPolygon.length-4).trim();
                            whichPolygon = whichPolygon.substr(0, whichPolygon.length-4).trim();
                            //좌표로만 되어 있는 상태
                            
                            var normalPolygon = whichPolygon.split("[");
                            for (var i = 1; i < normalPolygon.length; i++)
                            {
                                normalPolygon[i] = normalPolygon[i].split(']')[0].trim();
                            }
                            drawNormalPolygon(normalPolygon);                    
                        }
                        //구멍있는폴리곤이라면(구멍이 여러 개일 수 있기 때문에 2 초과)
                        else if (whichPolygon.split("[ [").length > 2)
                        {
                            //'['을 없애기 위해
                            whichPolygon = whichPolygon.substr(1, whichPolygon.length-1).trim();
                            var holePolygon = whichPolygon.split("[ [ ");

                            for (var i = 1; i < holePolygon.length; i++)
                            {
                                holePolygon[i] = "[" + holePolygon[i].split(" ] ]")[0] + "]";
                            }

                            var backGroup = holePolygon[1].split("[");
                            //첫번째 두번째는 해당하지 않으므로 -2
                            var holeGroup = new Array(holePolygon.length-2);

                            //배경폴리곤은 1부터
                            for(var i=1; i<backGroup.length; i++)
                            {
                                backGroup[i] = backGroup[i].split(']')[0].trim();
                            }

                            //구멍모양은 0부터
                            for(var i=0; i<holeGroup.length; i++)
                            {
                                holeGroup[i] = holePolygon[i+2].split("[")

                                for(var j=0; j<holeGroup[i].length; j++)
                                {
                                    holeGroup[i][j] = holeGroup[i][j].split(']')[0].trim();
                                }
                            }

                            drawHolePolygon(backGroup, holeGroup);
                        }
                    }

                    function drawNormalPolygon(normalPolygon)
                    {
                        var polygonPath = [];

                            for(var i=1; i < normalPolygon.length; i++)
                            {
                                polygonPath.push(new kakao.maps.LatLng(normalPolygon[i].split(",")[1].trim(), normalPolygon[i].split(",")[0].trim()));
                                points.push(new kakao.maps.LatLng(normalPolygon[i].split(",")[1].trim(), normalPolygon[i].split(",")[0].trim()));
                            }
                                                
                        // 지도에 표시할 다각형을 생성합니다
                        polygons.push(new kakao.maps.Polygon({
                            path:polygonPath, // 그려질 다각형의 좌표 배열입니다
                            strokeWeight: 3, // 선의 두께입니다
                            strokeColor: '#cf1717', // 선의 색깔입니다
                            strokeOpacity: 0.8, // 선의 불투명도 입니다 1에서 0 사이의 값이며 0에 가까울수록 투명합니다
                            strokeStyle: 'longdash', // 선의 스타일입니다
                            fillColor: '#f0c6c5', // 채우기 색깔입니다
                            fillOpacity: 0.7 // 채우기 불투명도 입니다
                        }));
                        
                        // 지도에 다각형을 표시합니다
                        polygons[polygons.length-1].setMap(map);
                    }

                    function drawHolePolygon(backGroup, holeGroup)
                    {
                        var path = [];
                        var hole = new Array(holeGroup.length);

                        for(var i=1; i < backGroup.length; i++)
                        {
                            path.push(new kakao.maps.LatLng(backGroup[i].split(",")[1].trim(), backGroup[i].split(",")[0].trim()));
                            points.push(new kakao.maps.LatLng(backGroup[i].split(",")[1].trim(), backGroup[i].split(",")[0].trim()));
                        }

                        for(var i=0; i < holeGroup.length; i++)
                        {
                            hole[i] = new Array(holeGroup[i].length);

                            for(var j=1; j<holeGroup[i].length; j++)
                            {
                                hole[i].push(new kakao.maps.LatLng(holeGroup[i][j].split(",")[1].trim(), holeGroup[i][j].split(",")[0].trim()));
                                points.push(new kakao.maps.LatLng(holeGroup[i][j].split(",")[1].trim(), holeGroup[i][j].split(",")[0].trim()));
                            } 
                        }
                                     
                        //구멍폴리곤 좌표 넣기
                        var pathPolygon = [path];

                        for(var i=0; i<hole.length; i++)
                        {
                            pathPolygon.push(hole[i]);
                        }

                        // 지도에 표시할 다각형을 생성합니다
                        polygons.push(new kakao.maps.Polygon({
                        path: pathPolygon, // 그려질 다각형의 좌표 배열입니다
                        strokeWeight: 3, // 선의 두께입니다
                        strokeColor: '#cf1717', // 선의 색깔입니다
                        strokeOpacity: 0.8, // 선의 불투명도 입니다 1에서 0 사이의 값이며 0에 가까울수록 투명합니다
                        strokeStyle: 'longdash', // 선의 스타일입니다
                        fillColor: '#f0c6c5', // 채우기 색깔입니다
                        fillOpacity: 0.7 // 채우기 불투명도 입니다
                        }));

                        // 지도에 다각형을 표시합니다
                        polygons[polygons.length-1].setMap(map);
                    }

                    /*
                    function moveTo(center)
                    {
                        //[ 삭제
                        center = center.substr(1, center.length-1).trim();
                            //] 삭제
                        center = center.substr(0, center.length-1).trim();

                        var moveLatLon = new kakao.maps.LatLng(center.split(",")[1].trim(), center.split(",")[0].trim()) // 지도의 중심좌표
                        map.panTo(moveLatLon);
                    }
                    */                    
                </script> 

                <link href="http://code.jquery.com/ui/1.12.0/themes/smoothness/jquery-ui.css" rel="Stylesheet"></link> 

                <script src="/resources/assets/js/jquery.min.js"></script>
                <script src="/resources/assets/js/jquery.scrolly.min.js"></script>
                <script src="/resources/assets/js/jquery.scrollex.min.js"></script>
                <script src="/resources/assets/js/browser.min.js"></script>
                <script src="/resources/assets/js/breakpoints.min.js"></script>
                <script src="/resources/assets/js/util.js"></script>
                <script src="/resources/assets/js/main.js"></script>

                <script src="http://code.jquery.com/ui/1.12.0/jquery-ui.js" ></script>

        </body>
    </html>