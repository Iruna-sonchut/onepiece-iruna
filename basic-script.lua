local json = require("dkjson")

function AddList(name, address, offset, type, value, status, save)
    local self = {}
    self[1] = {}
    self[1].name = name
    self[1].address = address + offset
    self[1].flags = type
    self[1].value = value
    self[1].freeze = status
    if value ~= nil then
        gg.setValues(self)
    end
    if save ~= false then
        gg.addListItems(self)
    end
    return self[1]
end

function search()
    gg.clearResults()
    gg.searchNumber("-1;3;1::9", gg.TYPE_DWORD)
    gg.refineNumber("3", gg.TYPE_DWORD)
    Results = gg.getResults(1)
    gg.clearResults()
    return Results[1].address
end

function Nawa(respon, X, Y)
    gg.clearResults()
    gg.searchNumber("256;256::5", gg.TYPE_DWORD)
    gg.refineNumber("256", gg.TYPE_DWORD)
    results = gg.getResults(300)
    
for i,v in ipairs(results) do
    A = gg.getValues({{address = v.address - 0x2D8, flags = gg.TYPE_DWORD}})[1].value
    if A == 100 then
        results = v.address
    end
end
    results = results - 0x2DC
    gg.clearResults()
    AddList(nil, results, 0x0, 4, respon, false, false)
    AddList(nil, results, -0x37, 1, X, false, false)
    AddList(nil, results, -0x2F, 1, Y, false, false)
    gg.sleep(500)
    AddList(nil, results, 0xA0, 4, 16842753, false, false)
    while gg.getValues({{address = results + 0xA0, flags = gg.TYPE_DWORD}})[1].value == 16842753 do
        gg.sleep(500)
    end
    return results
end

function Body_basic()
    text_c = {'ลบดีเลย์', 'ตรึงเลือด', 'ตีรัว', 'วิ่งไว[0; 10]', 'เดินทะลุ', 'ซ่อนชื่อ'}
    text_s = {[1]= 'checkbox', [2]= 'checkbox', [3]= 'checkbox', [4] = 'number', [5]= 'checkbox', [6]= 'checkbox'}
    text_sv = {}

    if hide_name ~= nil then
        if gg.getValues({{address = hide_name - 0xD0, flags = gg.TYPE_DWORD}})[1].value == 1 then
            text_sv[6] = true
        end
    end
    if body_address == nil then text_sv[4] = 1 else t = gg.getValues({{address = body_address + 0x24, flags = gg.TYPE_FLOAT}})[1].value; text_sv[4] = t end
    z = gg.getListItems()
    for i,v in ipairs(z) do
        if v.name == 'Delay' then text_sv[1] = true end
        if v.name == 'Blood' then text_sv[2] = true end
        if v.name == 'ATKSp' then text_sv[3] = true end
        if v.name == 'WallH' then text_sv[5] = true end
    end
    select_c = gg.prompt(text_c,text_sv,text_s)
    if select_c[1] or select_c[2] or select_c[3] or select_c[4] or select_c[5] then
        body_address = search()
        if select_c[1] == true then
            AddList("Delay", body_address, -0x70, 4, 0, true)
            AddList("Delay", body_address, -0x4C, 4, 0, true)
            AddList("Delay", body_address, -0x60, 4, 0, true)
        else
            z = gg.getListItems()
            for i,v in ipairs(z) do
                t = {}; if v.name == 'Delay' then table.insert(t,v) end; gg.removeListItems(t)
            end
        end
        if select_c[2] == true then
            t = gg.getValues({{address = body_address + 0x8, flags = gg.TYPE_DWORD}})[1].value
            AddList("Blood", body_address, 0x8, 4, t, true)
        else
            z = gg.getListItems()
            for i,v in ipairs(z) do
                t = {}; if v.name == 'Blood' then table.insert(t,v) end; gg.removeListItems(t)
            end
        end
        if select_c[3] == true then
            AddList("ATKSp", body_address, -0x3C, 4, 0, true)
            AddList("ATKSp", body_address, 0x2C, 4, 0, true)
        else
            z = gg.getListItems()
            for i,v in ipairs(z) do
                t = {}; if v.name == 'ATKSp' then table.insert(t,v) end; gg.removeListItems(t)
            end
        end
            AddList(nil, body_address, 0x24, 16, select_c[4], false,false)
        if select_c[5] == true then
            AddList('WallH', body_address, 0x58, 4, -65281, false)
        else
            AddList('WallH', body_address, 0x58, 4, 16842752, false)
            z = gg.getListItems()
            for i,v in ipairs(z) do
                t = {}; if v.name == 'WallH' then table.insert(t,v) end; gg.removeListItems(t)
            end
        end
    end
    if select_c[6] == true then
        gg.clearResults()
        gg.searchNumber("1;1;0;2000::13",gg.TYPE_DWORD)
        gg.refineNumber('2000', gg.TYPE_DWORD)
        hide_name = gg.getResults(1)[1].address;gg.clearResults()
        AddList('HideName', hide_name, -0xD0, 4, 1, false,false)
    elseif select_c[6] == false and hide_name ~= nil then
        AddList('HideName', hide_name, -0xD0, 4, 0, false,false)
    end
end

function Nawa_Select()
    text_c = {'บอส', 'เมือง', 'ใส่พิกัดสำหรับวาป', 'เก็บค่าพิกัดวาป'}
    select_c = gg.choice(text_c,nil,'')
    if select_c == 1 then Nawa(80010,50,108)
    elseif select_c == 2 then Nawa(80000,50,108)
    elseif select_c == 3 then
        text_c = gg.prompt({'เมือง', 'พิกัด X', 'พิกัด Y'},{},{[1] = 'number', [2] = 'number', [3] = 'number'})
        Nawa(text_c[1],text_c[2],text_c[3])
    elseif select_c == 4 then
        gg.clearResults()
        gg.searchNumber("256;256::5", gg.TYPE_DWORD)
        gg.refineNumber("256", gg.TYPE_DWORD)
        results = gg.getResults(300)
    for i,v in ipairs(results) do
        A = gg.getValues({{address = v.address - 0x2D8, flags = gg.TYPE_DWORD}})[1].value
        if A == 100 then
            results = v.address
        end
    end
    results = results - 0x2DC;gg.clearResults()
    text_one = gg.getValues({{address = results - 0x4, flags = gg.TYPE_DWORD}})[1].value
    text_two = gg.getValues({{address = results - 0x37, flags = gg.TYPE_BYTE}})[1].value
    text_three = gg.getValues({{address = results - 0x2F, flags = gg.TYPE_BYTE}})[1].value
    text_alert = 'เมือง : '..text_one..'\nพิกัด X : '..text_two..'\nพิกัด Y : '..text_three
    gg.alert(text_alert)
    end
end

function in_dirt()
    gg.clearResults()
    gg.searchNumber("0.1",gg.TYPE_FLOAT)
    gg.getResults(10)
    gg.editAll('0', gg.TYPE_FLOAT)
    gg.clearResults()
end


function starting()
    text_c = {'โปรพื้นฐาน', 'นาวาสายลม', 'วนบอส', 'ดำดิน','โอริคัลคุม', 'เพิ่มเติม'}
    table.insert(text_c, 'ออก')
    select_c = gg.choice(text_c,nil,"เช่าได้ที่ FB: สนฉัตร มาลาคุณ")

    if select_c == #text_c then gg.toast('กลับมาใช้บริการของเราอีกนะ');os.exit()
    elseif select_c == 1 then pcall(Body_basic)
    elseif select_c == 2 then pcall(Nawa_Select)
    elseif select_c == 3 then gg.alert('รออัพเดท')
    elseif select_c == 4 then pcall(in_dirt)
    elseif select_c == 5 then gg.alert('รออัพเดท')
    elseif select_c == 6 then gg.alert('รออัพเดท')
    end
end

hide_name,body_address = nil,nil

script = gg.makeRequest("https://raw.githubusercontent.com/Iruna-sonchut/onepiece-iruna/main/script_status.json").content
script = json.encode(script)
gg.alert(toString(script))
gg.clearResults()
clearSaveList = gg.getListItems()
gg.removeListItems(clearSaveList)
gg.setRanges(gg.REGION_JAVA_HEAP)
while false do
    if gg.isVisible(true) then
    gg.setVisible(false) starting() end end
