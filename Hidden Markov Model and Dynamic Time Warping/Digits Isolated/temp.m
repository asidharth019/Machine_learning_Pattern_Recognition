data8extract = untar('six.tgz','six');

for i = 1:.7*(length(data8extract))
    temp = load(data8extract{i});
    if i == 1
        data8 = temp;
    else
        data8 = [data8; temp];
    end
end

for i = .7*(length(data8extract))+1:length(data8extract)
    temp = load(data8extract{i});
    if i == .7*(length(data8extract))+1
        tdata8 = temp;
    else
        tdata8 = [tdata8; temp];
    end
end